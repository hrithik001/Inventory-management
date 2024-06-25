class Api::V1::CustomerOrder < Grape::API 
    helpers AuthHelpers
    resources :customer_orders do
        before do
            authenticate!
        end

        desc "get order's list"
        params do
             optional :status , type: String
        end
        get do
            status = params[:status]
            orders = CustomerOrder.get_orders(status)

            # present order,with: Entities::Order
            {
                orders: orders 
            }
        end



        desc "Create a new order"
        params  do
          requires :retailer_id, type: Integer, desc: "Retailer ID"
          requires :products, type: Array[Hash], desc: "Array of product variants"
        end
        post do
            
            order = CustomerOrder.create_new(params)
    
            if !order.persisted?
                error!(order.errors.full_messages.to_json, 422)
            end
    
            # present order, with: Entities::Order
            {
                order: order
            }
        end



    end
end