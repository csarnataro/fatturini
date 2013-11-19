class RemoveVariableFromFooterItems < ActiveRecord::Migration
  def change
    remove_column :footer_items, :variable, :string
  end
end
