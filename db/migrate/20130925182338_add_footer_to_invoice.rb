class AddFooterToInvoice < ActiveRecord::Migration
  def change
    add_reference :invoices, :footer, index: true
  end
end
