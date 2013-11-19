class AddBankAccountInfo < ActiveRecord::Migration
  def change
    add_column :companies, :bank_account_info, :text
  end
end
