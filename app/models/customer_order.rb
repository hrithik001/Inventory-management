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
                            CustomerOrder.where(status: status,retailer_id: Current.user)
                        else
                            CustomerOrder.where(retailer_id: Current.user)
                        end
                    end
    end

    def self.create_new(params)

        ActiveRecord::Base.transaction do
          order = CustomerOrder.new(
            delivery_date: nil,
            order_date: DateTime.now,
            expected_delivery_date: DateTime.now + 3,
            customer_id: Current.user.id,
            retailer_id: params[:retailer_id],
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
                error!('Order variant not found', 404) unless variant

                variant_price = VariantPrice.find_by(variant_id: variant_id)
                error!('Variant price not found', 404) unless variant_price

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
            raise ActiveRecord::Rollback, "Order not saved"
          end
          order
        end
        
    end




    

end
