class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :company, index: true
      t.string :email
      t.string :user_type
    end
  end
end
