class Api::V1::Orders < Grape::API 
  helpers AuthHelpers
  resources :orders do
      before do
          authenticate!
          authenticate_retailer!
      end


        
    desc "get order's list"
    params do
      optional :page, type: Integer, default: 1, desc: "Page number"
      optional :per_page, type: Integer, default: 5, desc: "orders per page"
      optional :status , type: String
    end
    get do
        page = params[:page] || 1
        per_page = params[:per_page] || 5
        status = params[:status]
        order = Order.get_orders(status)
        order = paginate(order)

        present order,with: Entities::Order
    end

    desc "get shipped orderes"
    params do
      optional :page, type: Integer, default: 1, desc: "Page number"
      optional :per_page, type: Integer, default: 5, desc: "orders per page"
    end

    get "shipped" do
      

      page = params[:page] || 1
      per_page = params[:per_page] || 5
      order = Order.shipped_orders
      order = paginate(order)


      
     
      present order, with: Entities::Order
     
    end

    desc "get particular shipped order details"
    get "shipped/:id" do
        order = Order.shipped_orders

        present order, with: Entities::OrderDetails
    end

    desc "add produts to inventory"
    params do
      requires :status, type: String
    end
    put "shipped/:id" do
        authenticate_retailer!
        if params[:status] == "DELIVERED"
          order = Order.find_by(id: params[:id])
          error!('Order not found', 404) unless order
          order = order.update_status(params)
          if order.status == "DELIVERED"
            puts "ended loop"
            order.create_inventory_transactions
            order.generate_rating_for_order
          else
            error!('Order status not updated', 401) 
          end    
        else
          error!("sorry , status can't be updated as #{params[:status]}")
        end
        
    end

    


    

    
    desc "get one order"
    get ":id" do
        order = Order.find_by(id: params[:id])
        present order, with: Entities::Order
    end


    desc "Create a new order"
    params do
      requires :supplier_id, type: Integer
      requires :products, type: Array do
        requires :variant_id, type: Integer
        requires :ordered_quantity, type: Integer
      end
    end
    post do
      authenticate_retailer!
        order = Order.create_new(params)

        if order.is_a?(Array) 
          error!(order.to_json, 422)
        elsif order.persisted?
          present order, with: Entities::Order
        else
          error!("Order not created", 401)
        end
    end
  end
end