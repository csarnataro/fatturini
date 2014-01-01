class AddBankRequiredToPaymentMode < ActiveRecord::Migration
  def change
    add_column :payment_modes, :bank_info_required, :boolean
  end
end
