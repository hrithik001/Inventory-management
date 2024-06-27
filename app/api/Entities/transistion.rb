class Api::Entities::Transistion < Grape::Entity
    expose :id
    expose :transition_type
    expose :quantity
    expose :transition_date
    expose :variant_id
    expose :retailer_id
end