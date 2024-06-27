class Api::V1::Customer < Grape::API 

    helpers AuthHelpers

    resources :customer do
        before do
            authenticate!
            authenticate_customer!
        end

       
        desc "customer profile"
        get  do
            
            customer = Customer.get_details
            present customer,with: Entities::Customer
        end
        desc "update profile"
        put  do
            user = User.find_by(id: Current.user.id)
            if user
                user.update_profile(params)
                if user.persisted?
                    customer = Customer.find_by(user_id: user )
                    present customer,with: Entities::Customer
                else
                    error!("user not updated",403)
                end

            else
                error!("user not exists",404)
            end
            
        end
            

        resources :orders do
            
            desc "get order's list"
            params do
                optional :page, type: Integer, default: 1, desc: "Page number"
                optional :per_page, type: Integer, default: 5, desc: "Transistions per page"
                optional :status , type: String
            end
            get do
                page = params[:page] || 1
                per_page = params[:per_page] || 5
                
                status = params[:status]

                orders = CustomerOrder.get_orders(status)
                orders = paginate(orders)

               
               
               { orders: orders , pagination: {
                page: page,
                per_page: per_page
               }}
            end

            desc "get order's details"
            params do
               
            end
            get ":id" do
                

                order = CustomerOrder.find_by(id: params[:id])
               present order,with: Entities::CustomerOrderDetails
            end


            

            desc "Create a new order"
            params  do
                requires :retailer_id, type: Integer, desc: "Retailer ID"
                requires :products, type: Array[Hash], desc: "Array of product variants"
            end
            post do
                
                    
                order = CustomerOrder.create_new(params)
            
                  

                if order.is_a?(CustomerOrder)
                    if order.persisted?
                    present order,with: Entities::Order
                    else
                    error!(order.errors.full_messages.to_json, 422)
                    end
                else
                    error!({ error: "Insufficient quantity for some variants", details: order[:insufficient_variants] }, 422)
                end
            end


        end

    end
end