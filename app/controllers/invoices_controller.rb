class InvoicesController < ApplicationController

  before_action :authenticate_user!

  before_action :set_invoice, only: [
                    :show, 
                    :edit, 
                    :update, 
                    :destroy, 
                    :print, 
                    :history, 
                    :download_file, 
                    :delete_history_file
                ]



  # GET /invoices
  # GET /invoices.json
  def index
    # @invoices = Invoice.order('invoice_date DESC') # equivalent of .all, which is deprecated
    @invoices = Invoice.where(
                  'client_id in (?)', 
                  current_user.company.clients.to_a.collect(&:id)).paginate(:page => params[:page]).order('invoice_date DESC')
    @invoices_sum = @invoices.collect(&:total).sum

  end

  def by_client
    # @invoices = Invoice.order('invoice_date DESC') # equivalent of .all, which is deprecated

    client_id = params[:client_id] 

    if current_user.company.clients.to_a.collect(&:id).include?(client_id.to_i) 
      @invoices = Invoice.where('client_id = (?)', client_id)
      @invoices_sum = @invoices.collect(&:total).sum
      
      @client = Client.find(client_id)
      
    else
      not_found and return
    end
  end


  # GET /invoices/1
  # GET /invoices/1.json
  def show
    respond_to do |format|
      format.html do 
        not_found and return unless @invoice
        render 'edit' 
      end

      format.pdf do 
        if @invoice.nil? || @invoice.status == 'paid' 
          not_found and return
        end
        generated_file_name = @invoice.generate_pdf(current_user, view_context)
        pdf_file_name = generated_file_name.split('/').last

        # removing the timestamp from the beginning of the file
        pdf_file_name = pdf_file_name[pdf_file_name.index('-')+1 .. pdf_file_name.length]
        sleep(1)
        send_file("#{Rails.root}/#{generated_file_name}",
              filename: pdf_file_name,
              type: "application/pdf")
      end
      # send_data(@invoice.generate_pdf('invoice'), :filename => "#{@invoice.id}.pdf", :type => "application/pdf")
      # format.pdf { render :pdf => @invoice.generate_pdf("invoice") } # render :layout => false }
    end    
  end

  def history
    @versions = @invoice.get_versions(current_user)
  end

  def download_file
    file_id = params[:file_id]

    right_file = nil
    dir = "#{Rails.root}/data/#{current_user.company.id}/#{@invoice.id}/"
    Dir.foreach(dir) do |file|
      next if file == '.' || file == '..' || File.extname(file) != '.pdf'
      right_file = file if file.starts_with? file_id
    end

    unless right_file.nil?
      send_file("#{dir}/#{right_file}",
            filename: right_file,
            type: "application/pdf")
    end
  end

  def delete_history_file
    file_id = params[:file_id]

    right_file = nil
    dir = "#{Rails.root}/data/#{current_user.company.id}/#{@invoice.id}/"
    Dir.foreach(dir) do |file|
      next if file == '.' || file == '..' || File.extname(file) != '.pdf'
      File.delete("#{dir}#{file}") if file.starts_with? file_id

    end

    remaining_pdf_files = 0
    Dir.foreach(dir) do |file|
      next if file == '.' || file == '..' || File.extname(file) != '.pdf'
      remaining_pdf_files += 1
    end

    @invoice.update_attributes(:status => :draft)

    redirect_to history_invoice_path(@invoice)
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
    not_found and return unless @invoice
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      
      
      # checking the new item, the one that is already on the page
      item = Item.new(new_item_params)

      if !item.quantity.nil? || !item.unit_cost.nil? || !item.description.blank?
        @invoice.items << item
      end
      
      
      if @invoice.save
        format.html { redirect_to invoice_path(@invoice), notice: 'Invoice was successfully created.' }
        format.json { render action: 'show', status: :draft, location: @invoice }
      else
        format.html { render action: 'new' }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update

    respond_to do |format|

      @invoice = Invoice.find(params[:id])

      # checking the new item, the one that is already on the page
      item = Item.new(new_item_params)

      if !item.quantity.nil? || !item.unit_cost.nil? || !item.description.blank?
        @invoice.items << item
      end

      if @invoice.update(invoice_params)

        # adding a new item if the "add item" submit was pressed
        if @invoice && params[:save_and_add_item]
          @invoice.items << Item.new
          @invoice.save
        end

        format.html { redirect_to invoice_path(@invoice), success: 'Invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy if @invoice.status == 'draft'
    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      # @invoice = Invoice.find(params[:id])
      # unless current_user.nil?
        @invoice = Invoice.where('id = ? and client_id in (?)', params[:id], current_user.company.clients.all.collect(&:id)).first
      #end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(
        :number, 
        :notes, 
        :term, 
        :status, 
        :client_id,
        :invoice_date,
        :payment_date,
        :footer_id,
        :items_attributes => [:id, :description, :quantity, :unit_cost, :total]
      )

    end

    def new_item_params 
      params.require(:invoice).require(:item).permit(:quantity, :description, :unit_cost, :total)
    end


end
