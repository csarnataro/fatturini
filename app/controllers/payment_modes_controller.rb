class PaymentModesController < ApplicationController
  before_action :set_payment_mode, only: [:show, :edit, :update, :destroy]

  # GET /payment_modes
  # GET /payment_modes.json
  def index
    @payment_modes = PaymentMode.all
  end

  # GET /payment_modes/1
  # GET /payment_modes/1.json
  def show
    respond_to do |format|
      format.html do 
        not_found and return unless @payment_mode
        render 'edit' 
      end
    end
  end

  # GET /payment_modes/new
  def new
    @payment_mode = PaymentMode.new
  end

  # POST /payment_modes
  # POST /payment_modes.json
  def create
    @payment_mode = PaymentMode.new(payment_mode_params)
      
    respond_to do |format|

      if @payment_mode.save
        format.html { redirect_to @payment_mode, notice: 'Payment mode was successfully created.' }
        format.json { render action: 'show', status: :created, location: @payment_mode }
      else
        format.html { render action: 'new' }
        format.json { render json: @payment_mode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_modes/1
  # PATCH/PUT /payment_modes/1.json
  def update
    respond_to do |format|
      if @payment_mode.update(payment_mode_params)
        format.html { redirect_to @payment_mode, notice: 'Payment mode was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @payment_mode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_modes/1
  # DELETE /payment_modes/1.json
  def destroy
    @payment_mode.destroy
    respond_to do |format|
      format.html { redirect_to payment_modes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_mode
      @payment_mode = PaymentMode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_mode_params
      params.require(:payment_mode).permit(:name, :full_description, :is_default, :bank_info_required)
    end
    
end
