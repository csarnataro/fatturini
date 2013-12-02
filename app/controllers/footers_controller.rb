class FootersController < ApplicationController
  before_action :set_footer, only: [:show, :edit, :update, :destroy]

  # GET /footers
  # GET /footers.json
  def index
    @footers = Footer.all
  end

  # GET /footers/1
  # GET /footers/1.json
  def show
  end

  def print
  end

  # GET /footers/new
  def new
    @footer = Footer.new
  end

  # GET /footers/1/edit
  def edit
    puts @footer.footer_items.inspect
  end

  # POST /footers
  # POST /footers.json
  def create
    @footer = Footer.new(footer_params)

    respond_to do |format|
      if @footer.save
        format.html { redirect_to edit_footer_path(@footer), notice: 'Footer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @footer }
      else
        format.html { render action: 'new' }
        format.json { render json: @footer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /footers/1
  # PATCH/PUT /footers/1.json
  def update

    respond_to do |format|

      @footer = Footer.find(params[:id])

      # checking the new item, the one that is already on the page
      footer_item = FooterItem.new(new_footer_item_params)

      if !footer_item.description.blank?
        @footer.footer_items << footer_item
      end

      puts @footer.footer_items.inspect

      if @footer.update(footer_params)

        # adding a new item if the "add item" submit was pressed
        if @footer && params[:save_and_add_item]
          @footer.footer_items << FooterItem.new
          @footer.save
        end

        format.html { redirect_to edit_footer_path(@footer), success: 'Footer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @footer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /footers/1
  # DELETE /footers/1.json
  def destroy
    @footer.destroy
    respond_to do |format|
      format.html { redirect_to footers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_footer
      @footer = Footer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def footer_params
      params.require(:footer).permit(
        :description, 
        :footer_items_attributes => [
          :id, 
          :description,
          :value,
          :summable,
          :formula,
          :percentage_label
        ]
      )

    end

    def new_footer_item_params 
      params.require(:footer).require(:footer_item).permit(:id, :description, :value, :summable, :percentage_label, :formula)
    end


end
