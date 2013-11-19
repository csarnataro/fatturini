class CreateMemos < ActiveRecord::Migration
  def change
    create_table :memos do |t|
      t.string :vendor
      t.string :goods
      t.decimal :amount
      t.references :company, index: true

      t.timestamps
    end
  end
end
