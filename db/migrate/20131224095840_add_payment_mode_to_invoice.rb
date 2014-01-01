class AddPaymentModeToInvoice < ActiveRecord::Migration
  def change
    add_reference :invoices, :payment_mode, index: true
  end
end
