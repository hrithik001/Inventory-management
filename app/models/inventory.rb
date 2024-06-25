class Inventory < ApplicationRecord
  belongs_to :variant
  belongs_to :user
  

  def decrease_quantity(quantity)
    puts "-----------------------------------decrementing quantity inside inventory by #{quantity}-------------------------------------"
    self.update(quantity_available: quantity_available - quantity)
  end

  def increase_quantity(quantity)
    puts "-----------------------------------incrementing quantity inside inventory by #{quantity}-------------------------------------"
    current_quantity = quantity_available || 0
    update(quantity_available: current_quantity + quantity)
  end

  
end
