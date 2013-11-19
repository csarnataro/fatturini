class CreateFooters < ActiveRecord::Migration
  def change
    create_table :footers do |t|
      t.text :description
    end
  end
end
