class AddBankAccountInfoToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :account_holder, :string
    add_column :companies, :iban, :string
    add_column :companies, :bank_name, :string
    add_column :companies, :bank_city, :string
    add_column :companies, :branch, :string
    add_column :companies, :bic, :string
    add_column :companies, :branch_bic, :string
  end
end
