class ChangeColumnItemQuantity < ActiveRecord::Migration
  def change
    change_column :items, :quantity, :decimal
  end
end
