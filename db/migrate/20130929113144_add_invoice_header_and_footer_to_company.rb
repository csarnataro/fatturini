class AddInvoiceHeaderAndFooterToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :invoice_header, :text
    add_column :companies, :invoice_footer, :text
  end
end
