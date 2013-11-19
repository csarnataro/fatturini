class AddDefaultTermToClient < ActiveRecord::Migration
  def change
    add_column :clients, :default_term, :string
  end
end
