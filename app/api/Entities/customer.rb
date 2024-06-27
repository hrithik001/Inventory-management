module Entities
    class Customer < Grape::Entity
        expose :name do |customer|
            customer.user.name
          end
          
        expose :email do |customer|
        customer.user.email
        end
    
        expose :contact
        expose :address
    end
end