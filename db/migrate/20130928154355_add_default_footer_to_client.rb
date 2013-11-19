class AddDefaultFooterToClient < ActiveRecord::Migration
  def change
    add_reference :clients, :footer, index: true
  end
end
