class AddFieldsToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :telephone, :string
    add_column :companies, :email, :string
    add_column :companies, :city, :string
    add_column :companies, :province, :string
    add_column :companies, :state, :string
    add_column :companies, :country, :string
    add_column :companies, :zip, :string
    add_column :companies, :fiscal_code, :string
    add_column :companies, :vat_code, :string
  end
end
