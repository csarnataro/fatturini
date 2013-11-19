class AddAttentionToClient < ActiveRecord::Migration
  def change
    add_column :clients, :attention_to, :string
  end
end
