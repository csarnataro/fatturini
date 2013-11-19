class RemoveBankCityFromCompanies < ActiveRecord::Migration
  def change
    remove_column :companies, :bank_city, :string
  end
end
