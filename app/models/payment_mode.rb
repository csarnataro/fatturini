class PaymentMode < ActiveRecord::Base
  before_save :at_least_one_default_exists
  before_destroy :set_another_default
  validates :name, :full_description, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false

  # validate :at_least_one_default_exists
  has_many :invoices 
  has_many :clients
  

private  

  def set_another_default
    if self.is_default?
      PaymentMode.order(:id).first.update({:is_default => true})
    end
  end

  def at_least_one_default_exists
    if self.is_default?
      if self.new_record?
        PaymentMode.update_all({:is_default => false })
      else
        PaymentMode.where('id <> ? and is_default', self.id).update_all({:is_default => false })
      end
    else 
      if PaymentMode.where('id = ? and is_default', self.id).count == 1
        self.is_default = true
      end
    end
  end
  
end
