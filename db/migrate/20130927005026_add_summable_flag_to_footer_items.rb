class AddSummableFlagToFooterItems < ActiveRecord::Migration
  def change
    add_column :footer_items, :summable, :boolean
  end
end
