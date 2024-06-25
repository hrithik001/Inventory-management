class Supplier < ApplicationRecord
  belongs_to :user
  has_many :supplier_metrics, dependent: :destroy

  def update_average_ratings
    total_ratings = supplier_metrics.count
    return if total_ratings.zero?

    self.delivery_time_accuracy = supplier_metrics.average(:delivery_time_rating).to_f.round(2)
    self.order_accuracy = supplier_metrics.average(:order_accuracy_rating).to_f.round(2)
    puts "inside supplier overall rating"
    puts "-------------delivery time #{self.delivery_time_accuracy}------------------"
    puts "-------------order accuracy #{self.order_accuracy}------------------------"
    save!
  end

end
