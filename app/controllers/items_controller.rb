class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :destroy]

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to edit_invoice_path(@item.invoice.id) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:invoice, :description, :unit_cost, :unit_cost, :quantity, :discount)
    end
end
