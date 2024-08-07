module Entities
    class Supplier < Grape::Entity
        expose :id do |supplier|
            supplier.user.id
        end
        expose :name do |supplier|
            supplier.user.name
          end
          
        expose :email do |supplier|
        supplier.user.email
        end
    
        expose :contact
        expose :notes
        expose :delivery_time_accuracy
        expose :order_accuracy
        
    end
end