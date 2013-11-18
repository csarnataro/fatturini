class MemosController < ApplicationController
  before_action :set_memo, only: [:show, :edit, :update, :destroy]

  # GET /memos
  # GET /memos.json
  def index
    @memos = current_user.company.memos.order('creation_date DESC')
    # @memos = Memo.all
  end

  # GET /memos/1
  # GET /memos/1.json
  def show
    not_found and return unless @memo
    render :edit
  end

  # GET /memos/new
  def new
    @memo = Memo.new
  end

  # GET /memos/1/edit
  def edit
    not_found and return
  end

  # POST /memos
  # POST /memos.json
  def create
    params[:memo][:company_id] = current_user.company.id
    @memo = Memo.new(memo_params)

    @memo.creation_date = DateTime.now
    
    respond_to do |format|
      if @memo.save
        format.html { redirect_to @memo, notice: 'Memo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @memo }
      else
        format.html { render action: 'new' }
        format.json { render json: @memo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memos/1
  # PATCH/PUT /memos/1.json
  def update
    params[:memo][:company_id] = current_user.company.id
    respond_to do |format|
      if @memo.update(memo_params)
        format.html { redirect_to @memo, notice: 'Memo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @memo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memos/1
  # DELETE /memos/1.json
  def destroy
    @memo.destroy
    respond_to do |format|
      format.html { redirect_to memos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_memo
      # @memo = Memo.find(params[:id])
      @memo = Memo.where('id = ? and company_id = ?', params[:id], current_user.company.id).first

      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def memo_params
      params.require(:memo).permit(:vendor, :goods, :amount, :company_id, :creation_date)
    end
end
