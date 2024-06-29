class CustomerOrder < ApplicationRecord
    belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
    belongs_to :retailer, class_name: 'User', foreign_key: 'retailer_id'
    has_many :customer_order_variants, dependent: :destroy

    def self.get_orders(status)
        "-------------------------------------------inside get orders-------------------------------------------------------"
        orders =    if Current.user&.role == "CUSTOMER"
                        if status
                            CustomerOrder.where(status: status,customer_id: Current.user)
                        else
                            CustomerOrder.where(customer_id: Current.user)
                        end
                    elsif Current.user&.role == "RETAILER"
                        if status
                            CustomerOrder.where(status: status)
                        else
                            CustomerOrder.all
                        end
                    end
    end

    def self.create_new(params)

        # check at db, can we have sufficient quantity ?
        
        can_fullfill = check_variant_availability(params)

        puts can_fullfill.inspect, "******************************************************************************"

        if can_fullfill.any?
          return { insufficient_variants: can_fullfill }
        end

        puts "can be fullfill_______________________________________________________-"

        ActiveRecord::Base.transaction do
          order = CustomerOrder.new(
            delivery_date: nil,
            order_date: DateTime.now,
            expected_delivery_date: DateTime.now + 3,
            customer_id: Current.user.id,
            retailer_id: 1,
            status: "PENDING",
            total_amount: 0.00
          )
          
          
          if order.save
            puts "Order details -> #{params[:products].inspect}------------------"
    
            total_amount = 0
            params[:products].each do |product_params|
             
              variant_id = product_params[:variant_id]
                ordered_quantity = product_params[:ordered_quantity]
              
              
                variant = Variant.find_by(id: variant_id)
                

                variant_price = VariantPrice.find_by(variant_id: variant_id)
                raise ActiveRecord::RecordInvalid.new(self), "price is not decided for this variant #{variant.inspect}" unless variant_price

                selling_price = variant_price.selling_price
                base_price = variant_price.base_price
                puts "selling price is #{selling_price}--------#{base_price}------------------------------"
                total_amount += selling_price * ordered_quantity


                order.customer_order_variants.create!(
                    variant_id: variant_id,
                    ordered_quantity: ordered_quantity
                )
    
            #   puts "CustomerOrderVariant #{customer_order_varient.inspect}"
            end
            order.update!(total_amount: total_amount)
          else
            puts "inside rollback___________________________________________"
            raise ActiveRecord::Rollback, "Order not saved"
          
          end
          order
        end
        
    end

    def self.check_variant_availability(params)
      insufficient_variants = []
      retailer = User.find_by(role: "RETAILER")

      if !retailer 
        insufficient_variants << { status: "Retailer not exists" }
      else
  
        params[:products].each do |product_params|
          variant = Variant.find_by(id: product_params[:variant_id])
          if variant
            unless variant&.is_quantity_available?(product_params[:ordered_quantity])
              insufficient_variants << { variant_id: variant.id, requested_quantity: product_params[:ordered_quantity], available_quantity: variant.quantity_available }
            end
          else
            insufficient_variants << { variant_id: product_params[:variant_id], status: "variant not exists"} 
          end
          
        end
      end
  
      insufficient_variants
    end

    def update_status(status)
      self.update(status: status)
    end

    def manage_order(status)
      
      return update_status(status) if status == 'CANCELLED'
      
      fulfill_order  #create a inventory transistion 'out' and also maintain the quantity count of variant in inventory
      update_status(status) # update to shipped
      self.update(delivery_date: DateTime.now)


    end

    def fulfill_order
      self.customer_order_variants.each do |order_variant|
        variant = Variant.find(order_variant.variant_id)
        inventory = Inventory.find_by(variant_id: variant.id)
        
  
        
        inventory.decrease_quantity(order_variant.ordered_quantity)
        InventoryTransition.create!(
          transition_type: 'OUT',
          quantity: order_variant.ordered_quantity,
          transition_date: DateTime.now,
          variant_id: variant.id,
          retailer_id: Current.user.id
        )
  
        order_variant.update(supplied_quantity: order_variant.ordered_quantity)
      end
    end




    

end
