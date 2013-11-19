class AddCompanyIdToClient < ActiveRecord::Migration
  def change
    add_reference :clients, :company, index: true
  end
end
