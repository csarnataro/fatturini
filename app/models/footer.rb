class Footer < ActiveRecord::Base

    has_many :footer_items, :dependent => :destroy
    has_many :invoices 
    has_many :clients

    accepts_nested_attributes_for :footer_items, :allow_destroy => true

end
