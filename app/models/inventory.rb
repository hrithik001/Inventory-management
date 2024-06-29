class Inventory < ApplicationRecord
  belongs_to :variant
  belongs_to :user
  

  def decrease_quantity(quantity)
    puts "**************************inside function******************"
    self.update(quantity_available: quantity_available - quantity)
    
  end

  def increase_quantity(quantity)
    
    current_quantity = quantity_available || 0
    
    update(quantity_available: current_quantity + quantity)
    
  end

  def self.get_inventory
    Inventory.all
  end


  
end
