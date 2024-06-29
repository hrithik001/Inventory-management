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
            authenticate_retailer!
            status = params[:status]
            orders = CustomerOrder.get_orders(status)

            
            present orders, with: Entities::Order
        end
        desc "get order's details"
        
        get ":id" do
            
            
            orders = CustomerOrder.find_by(id: params[:id])

            
            present orders, with: Entities::CustomerOrderDetails
        end



        desc "fullfill customer orders"
        params do
            requires :status, type: String, desc: "customer order status"
        end
        put ":id" do
            authenticate_retailer!
            customer_order = CustomerOrder.find_by(id: params[:id])
            status = params[:status]
            customer_order.manage_order(status)
            present customer_order,with: Entities::CustomerOrderDetails
        end



    end
end