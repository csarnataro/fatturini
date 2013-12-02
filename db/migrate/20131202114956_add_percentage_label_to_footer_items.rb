class AddPercentageLabelToFooterItems < ActiveRecord::Migration
  def change
    add_column :footer_items, :percentage_label, :string
  end
end
