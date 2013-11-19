class AddDefaultNotesToClient < ActiveRecord::Migration
  def change
    add_column :clients, :default_notes, :string
  end
end
