class FooterItemsController < ApplicationController
  before_action :set_footer_item, only: [:show, :destroy]

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @footer_item.destroy
    respond_to do |format|
      format.html { redirect_to edit_footer_path(@footer_item.footer.id) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_footer_item
      @footer_item = FooterItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:footer_item).permit(:id, :description)
    end
end
