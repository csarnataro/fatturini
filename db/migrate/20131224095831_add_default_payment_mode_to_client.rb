class AddDefaultPaymentModeToClient < ActiveRecord::Migration
  def change
    add_reference :clients, :payment_mode, index: true
  end
end
