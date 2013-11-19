class AddInvoiceLanguageToClient < ActiveRecord::Migration
  def change
    add_column :clients, :invoice_language, :string
  end
end
