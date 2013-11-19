class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :city
      t.string :province
      t.string :state
      t.string :country
      t.string :zip
      t.string :fiscal_code
      t.string :vat_code

      t.timestamps
    end
  end
end
