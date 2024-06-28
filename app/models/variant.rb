class Variant < ApplicationRecord
  belongs_to :product
  has_many :properties

  has_many :order_variant
  has_many :orders, through: :order_variant
  has_many :customer_order_variants
  has_many :inventories


  
  has_many :variant_prices

  def current_selling_price
    variant_prices.last&.selling_price || calculate_selling_price(price)
  end
  def base_price
    variant_prices.last&.base_price || 0
  end

  def calculate_average_selling_price
    inventory = Inventory.find_by(variant_id: self.id)
    puts "********************8#{inventory.inspect}*****************************"
    variant_prices_count = variant_prices.count
    return price if variant_prices_count.zero? || inventory.quantity_available.zero?
    puts "****************calculating average , not returned*********************"
    average_price = variant_prices.last&.average_selling_price + price 
    average_price / 2
  end

  def calculate_selling_price(average_selling_price)

    profit_margin = 20
    
    average_selling_price * (1 + profit_margin / 100.0)
  end

  def quantity_available
    inventories.sum(:quantity_available)
  end

  def is_quantity_available?(requested_quantity)
    puts "_________________________________quantity avilabel #{quantity_available}_ & requested quantity #{requested_quantity}_________________________________"
    quantity_available >= requested_quantity
  end

  def delete_if_allowed
    
    # return { error: 'Variant cannot be deleted as it having order history' } if order_variant.any?
    return { error: 'Variant cannot be deleted as it having transistion history' } if inventory_transistion?
   

    # Delete associated properties
    properties.destroy_all
    
    # Delete from other associations
    variant_prices.destroy_all
    
    # Delete the variant itself
    destroy
    { status: 'deleted' }
  rescue StandardError => e
    { error: "Error deleting variant: #{e.message}" }
  end


  def inventory_transistion?
    transistion = InventoryTransition.where(variant_id: self.id)
    return transistion.present?
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id price]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[properties]
  end



end
