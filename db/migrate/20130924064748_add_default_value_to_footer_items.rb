class AddDefaultValueToFooterItems < ActiveRecord::Migration
  def change
    add_column :footer_items, :default_value, :string
  end
end
