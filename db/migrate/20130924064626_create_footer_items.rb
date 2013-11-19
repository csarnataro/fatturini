class CreateFooterItems < ActiveRecord::Migration
  def change
    create_table :footer_items do |t|
      t.text :description
      t.string :variable
      t.string :value
      t.text :formula
      t.references :footer, index: true
    end
  end
end
