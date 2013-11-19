class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.text :notes
      t.text :term
      t.string :status
      t.references :client, index: true

      t.timestamps
    end
  end
end
