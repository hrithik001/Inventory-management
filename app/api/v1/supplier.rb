class Api::V1::Supplier < Grape::API 
    helpers AuthHelpers
    resources :supplier do

        before do 
            authenticate!
            authenticate_supplier!
        end

        

        desc "supplier profile"
        get do
            supplier = Supplier.get_user
            present supplier,with: Entities::Supplier
        end

        desc "Edit Profile"
        put  do
            user = User.find_by(id: Current.user.id)
            if user
                user.update_profile(params)
                if user.persisted?
                    supplier = Supplier.find_by(user_id: user.id)
                    present supplier,with: Entities::Supplier
                else
                    error!("user not updated",403)
                end

            else
                error!("user not exists",404)
            end
            
        end

        resources :orders do
            desc "orders"
            params do
                optional :page, type: Integer, default: 1, desc: "Page number"
                optional :per_page, type: Integer, default: 5, desc: "Order per page"
                optional :status , type: String
              end
            get do
                status = params[:status]
                page = params[:page]
                per_page = params[:page]

                orders = Order.get_orders(status)
                orders = paginate(orders)

                present orders,with: Entities::Order
            end

            desc 'Update order status, supplied quantity, and variant price'
            params do
            
            requires :status, type: String, desc: 'Order Status'
            optional :supplied_quantities, type: Array do
                requires :variant_id, type: Integer, desc: 'Variant ID'
                requires :supplied_quantity, type: Integer, desc: 'Supplied Quantity'
                requires :price, type: Integer, desc: 'Price' 
            end
            end

           
            put ':id' do

            

                order = Order.find_by(id: params[:id])

                error!('Order not found', 404) unless order

                result = order.update_order(params)

                if result.is_a?(Order)
                    present result, with: Entities::Order
                else
                    error!("failed to update",422)
                end

               
            end

            desc "get order detail info"
            get ':id' do

                order = Order.find_by(id: params[:id])

                error!('Order not found', 404) unless order

                result = order.update_order(params)

                if !result.persisted?
                    error!(result.errors.full_message.to_json,422)
                end

                present result, with: Entities::OrderDetails
            end

          


           

        end

    end

end