class CreatePaymentModes < ActiveRecord::Migration
  def change
    create_table :payment_modes do |t|
      t.string :name
      t.string :full_description
      t.boolean :is_default

      t.timestamps
    end
  end
end
