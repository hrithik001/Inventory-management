class SupplierMetric < ApplicationRecord
  belongs_to :supplier
  belongs_to :order


  def self.generate_rating(order) 

    
    
    delivery_time_rating = calculate_delivery_time_rating(order)
    order_accuracy_rating = calculate_order_accuracy_rating(order)

    puts "-------------------delivery time rating #{delivery_time_rating}----------------------------"
    puts "--------------------order accuracy rating #{order_accuracy_rating}----------------------"

    user_id  = order.supplier.id
    supplier = Supplier.find_by(user_id: user_id)
    puts "--------------------------#{supplier.inspect}-----------------------------"
    SupplierMetric.create!(
      supplier: supplier,
      order: order,
      delivery_time_rating: delivery_time_rating,
      order_accuracy_rating: order_accuracy_rating
    )
    
    supplier.update_average_ratings
  end

  def self.calculate_delivery_time_rating(order)
    delivery_date = order.delivery_date
    expected_delivery_date = order.expected_delivery_date
    return 0 if order.status == "CANCELLED" # if supplier cancelled the order
    return 5 if delivery_date <= expected_delivery_date

    days_late = (delivery_date - expected_delivery_date).to_i

    case days_late
    when 1..2
      4
    when 3..5
      3
    when 6..10
      2
    else
      1
    end
  end

  def self.calculate_order_accuracy_rating(order)
    return 0 if order.status == "CANCELLED"

    total_expected_quantity = 0
    total_supplied_quantity = 0

    order.order_variant.each do |order_variant|
      total_expected_quantity += order_variant.ordered_quantity
      total_supplied_quantity += order_variant.supplied_quantity
    end

    accuracy_percentage = (total_supplied_quantity.to_f / total_expected_quantity) * 100

    case accuracy_percentage
    when 90..100
      5
    when 75..89
      4
    when 65..74
      3
    when 40..64
      2
    else
      1
    end
  end
end
