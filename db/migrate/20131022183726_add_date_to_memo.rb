class AddDateToMemo < ActiveRecord::Migration
  def change
    add_column :memos, :creation_date, :date
  end
end
