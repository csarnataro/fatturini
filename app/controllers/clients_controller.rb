class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy, :defaults]

  # GET /clients
  # GET /clients.json
  def index
    @clients = current_user.company.clients.order('name DESC')
    # @clients = Client.all
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    not_found and return unless @client
    render 'edit'
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
    not_found and return
  end

  # POST /clients
  # POST /clients.json
  def create
    params[:client][:company_id] = current_user.company.id # This will overwrite the client_id sent in the hidden field

    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to client_path(@client), notice: 'Client was successfully created.' }
        format.json { render action: 'show', status: :created, location: @client }
      else
        format.html { render action: 'new' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    not_found and return unless @client
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to client_path(@client), notice: 'Client was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    begin
      @client.destroy
    rescue ActiveRecord::DeleteRestrictionError => e
      @client.errors.add(:base, e)
      flash[:error] = "#{e}"
    ensure
      respond_to do |format|
        format.html { redirect_to clients_url }
        format.json { head :no_content }
      end
    end
    
  end

  def defaults
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client

      # @client = Client.find(params[:id])
      @client = Client.where('id = ? and company_id = ?', params[:id], current_user.company.id).first

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(
        :company_id,
        :name, 
        :email, 
        :salutation, 
        :address, 
        :city, 
        :province, 
        :state, 
        :country, 
        :zip, 
        :fiscal_code, 
        :vat_code,
        :attention_to,
        :default_term,
        :payment_mode_id,
        :footer_id,
        :invoice_language,
        :default_notes

      )
    end
end
