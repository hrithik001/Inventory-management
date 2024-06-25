class OrderVariant < ApplicationRecord
    belongs_to :order
    belongs_to :variant
end