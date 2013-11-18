class Item < ActiveRecord::Base

  belongs_to :invoice

  after_save :update_total

  private
    def update_total

      p self.unit_cost.inspect
      p "*********** unit cost is integer? #{self.unit_cost.to_i.is_a? Integer}"

      if !self.unit_cost.nil? && !self.quantity.nil? && (self.unit_cost.to_f.is_a? Float) && (self.quantity.to_f.is_a? Float)
        begin
          total = self.unit_cost  * self.quantity # * ((100 - discount) / 100.0)  
        rescue
          total = nil
        end
        self.update_column(:total, total)
      end
      

    end


=begin  

  def total=(value) 
    if unit_cost.kind_of? Integer and quantity.kind_of? Integer
      total = unit_cost  * quantity # * ((100 - discount) / 100.0)  
    else
      total = value.to_f
    end

  end



  def total_price
    unit_cost  * quantity # * ((100 - discount) / 100.0)
  rescue # NoMethodError => method
    return 0
  end
=end

end
