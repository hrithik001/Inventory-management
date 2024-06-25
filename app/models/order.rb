class Order < ApplicationRecord
 
  VALID_STATUS = ["PENDING","SHIPPED","DELIVERED","CANCELLED"]
  belongs_to :retailer, class_name: 'User', foreign_key: 'retailer_id'
  belongs_to :supplier, class_name: 'User', foreign_key: 'supplier_id'

  has_many :order_variant
  has_many :variant, through: :order_variant

  has_many :order_variant, dependent: :destroy
 
  def self.get_orders(status)
    orders = if Current.user.role == 'RETAILER'
                if status
                    Order.where(retailer_id: Current.user, status: status)
                else
                    Order.where(retailer_id: Current.user)
                end
              elsif Current.user.role == 'SUPPLIER'
                if status
                  Order.where(supplier_id: Current.user,status: status)
                else
                  Order.where(supplier_id: Current.user,status: 'PENDING')
                end
              end
    orders
  end


  def self.create_new(params)

    order = Order.new(
      delivery_date: nil,
      order_date: DateTime.now,
      expected_delivery_date: DateTime.now + 3,
      retailer_id: Current.user.id,
      supplier_id: params[:supplier_id],
      status: "PENDING",
      total_amount: 0.00

    )

    order.save

    params[:products].each do |product_params|
      variant_id = product_params[:variant_id]
      ordered_quantity = product_params[:ordered_quantity]

      order.order_variant.create!(
        variant_id: variant_id,
        ordered_quantity: ordered_quantity
      )
    end


    order
  end

  def update_order(params)
      
    puts "self order #{self.inspect}"
    total_amount = BigDecimal('0')
      ActiveRecord::Base.transaction do
        self.update!(status: params[:status])
        if self.status == "SHIPPED"
          puts "-------------------im inside-----------------------------"
          self.update!(delivery_date: DateTime.now)

          params[:supplied_quantities].each do |supplied|

            order_variant = self.order_variant.find_by(variant_id: supplied[:variant_id])
            puts "-----------------------------variant got #{self.order_variant.inspect}- #{supplied[:variant_id]}----------------------------"
            return create_new_error("variant not exists") unless order_variant

            order_variant.update!(supplied_quantity: supplied[:supplied_quantity])
            
            variant = Variant.find(supplied[:variant_id])
            variant.update!(price: supplied[:price])

            total_amount += BigDecimal(supplied[:price].to_s) * supplied[:supplied_quantity]
          end
        elsif self.status == "CANCELLED"
          self.generate_rating_for_order
          puts "------------------inside cancelled------------------------------ "
        end
      end
      self.update!(total_amount: total_amount)
      self
  end


  def update_status(params)
    self.update(status: params[:status])
    
    self
  end

  def generate_rating_for_order
    SupplierMetric.generate_rating(self)
    
  end

  def create_inventory_transactions
    # puts "Start transition"
  
    self.order_variant.each do |_order_variant|
     
      variant = _order_variant.variant
    
      base_price = variant.price


      base_price = variant.price

      average_selling_price = variant.calculate_average_selling_price  
      selling_price = variant.calculate_selling_price(average_selling_price)

      puts " for variant #{variant.id}"
      puts "base_price $$$$$$$$$$$$$$$$$-- #{base_price}--"
      puts "average price $$$$$$$$$$$$$$$$-- #{average_selling_price}---"
      puts "selling price -4$$$$$$$$$$$$$$$$$$y- #{selling_price}-----"

      inventory = Inventory.find_or_create_by(variant_id: variant.id, user_id: self.retailer_id)
      inventory.increase_quantity(_order_variant.supplied_quantity)

      variant.variant_prices.create!(
        base_price: base_price,
        average_selling_price: average_selling_price,
        selling_price: selling_price
      )
      
      
      InventoryTransition.create!(
        variant_id: variant.id,
        retailer_id: self.retailer_id,
        transition_type: "IN",
        quantity: _order_variant.supplied_quantity,
        transition_date: Time.zone.now
      )

    end
 
    
  end

  def self.create_new_error(error_message)
    order = new
    # puts "-----------creating a new error---------------"
    order.errors.add(:base, error_message)
    usorderer
  end

end
