class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :invoice, index: true
      t.text :description
      t.decimal :unit_cost, :precision => 8, :scale => 3
      t.integer :quantity
      t.decimal :discount, :precision => 5, :scale => 2

      t.timestamps
    end
  end
end
