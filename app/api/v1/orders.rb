class Api::V1::Orders < Grape::API 
  helpers AuthHelpers
  resources :orders do
      before do
          authenticate!
      end


        
    desc "get order's list"
    params do
      optional :status , type: String
    end
    get do
        status = params[:status]
        order = Order.get_orders(status)

        present order,with: Entities::Order
    end

    desc "get shipped orderes"
    get "shipped" do
      authenticate_retailer!

      order = Order.where(retailer_id: Current.user, status: "SHIPPED")

      present order, with: Entities::Order

    end

    desc "get particular shipped order details"
    get "shipped/:id" do
        order = Order.where(id: params[:id],status: "SHIPPED")

        present order, with: Entities::Order
    end

    desc "add produts to inventory"
    params do
      requires :status, type: String
    end
    put "shipped/:id" do
        authenticate_retailer!
        if params[:status] == "DELIVERED"
          order = Order.find_by(id: params[:id])
          order = order.update_status(params)
          if order.status == "DELIVERED"
            puts "ended loop"
            order.create_inventory_transactions
            order.generate_rating_for_order
          else
            {"message": "not updated"}
          end    
        else
          error!("sorry , status can't be updated as #{params[:status]}")
        end
        
    end

    


    

    desc "get delivered orderes"
    get "delivered" do
      authenticate_retailer!

      order = Order.where(retailer_id: Current.user, status: "DELIVERED")

      present order, with: Entities::Order

    end
    
    desc "get one order"
    get ":id" do
        order = Order.find_by(id: params[:id])
        present order, with: Entities::Order
    end


    desc "Create a new order"
    params do
      requires :supplier_id, type: Integer, desc: "Supplier ID"
      requires :products, type: Array[Hash], desc: "Array of product variants"
    end
    post do
      authenticate_retailer!
        order = Order.create_new(params)

        if !order.persisted?
          error!(order.errors.full_message.to_json,422)
        end

        present order, with: Entities::Order
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

    # for supplier to update the order as SHIPPED 
    put ':id' do

      authenticate_supplier!

      order = Order.find_by(id: params[:id])

      error!('Order not found', 404) unless order

      result = order.update_order(params)

      if !result.persisted?
          error!(result.errors.full_message.to_json,422)
      end

      present result, with: Entities::Order
    end


          
        
        

       
  
    

       
       
       

        
    end
end