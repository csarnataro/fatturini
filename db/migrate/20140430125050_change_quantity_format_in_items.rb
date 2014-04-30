class ChangeQuantityFormatInItems < ActiveRecord::Migration
  def change
    change_column :items, :quantity, :decimal, :precision => 8, :scale => 3
  end
end
