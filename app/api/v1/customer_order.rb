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
    
            # result = CustomerOrder.create_new(params)

          if order.is_a?(CustomerOrder)
            if order.persisted?
              { order: order}
            else
              error!(order.errors.full_messages.to_json, 422)
            end
          else
            error!({ error: "Insufficient quantity for some variants", details: order[:insufficient_variants] }, 422)
          end
        end

        params do
            requires :status, type: String, desc: "customer order status"
        end
        put ":id" do
            customer_order = CustomerOrder.find_by(id: params[:id])
            status = params[:status]
            customer_order.manage_order(status)


        end



    end
end