class InventoryTransition < ApplicationRecord
  
  validates :transition_type, inclusion: { in: %w(IN OUT), message: "%{value} is not a valid transition type" }
  validates :quantity, numericality: { greater_than: 0 }
  validates :transition_date, presence: true

  def self.search(transition_type)

      
    transistion = if transition_type
                        InventoryTransition.where(transition_type: transition_type)
                  else
                        InventoryTransition.all
                  end
    transistion


  end
end
