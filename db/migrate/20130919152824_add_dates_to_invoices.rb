class AddDatesToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :creation_date, :date
    add_column :invoices, :invoice_date, :date
    add_column :invoices, :payment_date, :date
  end
end
