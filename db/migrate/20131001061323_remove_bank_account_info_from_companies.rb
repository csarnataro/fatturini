class RemoveBankAccountInfoFromCompanies < ActiveRecord::Migration
  def change
    remove_column :companies, :bank_account_info, :text
  end
end
