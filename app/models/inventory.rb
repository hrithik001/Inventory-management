class Inventory < ApplicationRecord
  belongs_to :variant
  belongs_to :user
  

  def decrease_quantity(quantity)
    puts "************************ previous quantity - #{self.quantity_available}****************************************"
    puts "************************ decrases by - #{quantity}****************************************"
    self.update(quantity_available: quantity_available - quantity)
    puts "************************ updated quantity - #{self.quantity_available}****************************************"
   
  end

  def increase_quantity(quantity)
    
    current_quantity = quantity_available || 0
    puts "************************ previous quantity - #{current_quantity}****************************************"
    puts "************************ increase by - #{quantity}****************************************"
    update(quantity_available: current_quantity + quantity)
    puts "************************ updated quantity - #{self.quantity_available}****************************************"
  end

  def self.get_inventory
    Inventory.where(user_id: Current.user)
  end


  
end
