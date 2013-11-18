class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies
  # GET /companies.json
  def index
    if current_user.admin?
      @companies = Company.all
    else
      not_found and return
    end

  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    render :edit
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
    not_found and return
  end

  # POST /companies
  # POST /companies.json
  def create
    unless current_user.admin?
      not_found and return
    end

    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to company_path(@company), notice: 'Company was successfully created.' }
        format.json { render action: 'show', status: :created, location: @company }
      else
        format.html { render action: 'new' }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to company_path, notice: 'Company was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    unless current_user.admin?
      not_found and return
    end

    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(
        :name, 
        :address, 
        :invoice_header, 
        :invoice_footer, 
        :account_holder,
        :bank_name,
        :iban,
        :branch,
        :bic,
        :branch_bic
        )
    end
end
