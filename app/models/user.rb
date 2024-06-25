class User < ApplicationRecord

    has_secure_password

    VALID_ROLES = ['RETAILER', 'SUPPLIER', 'CUSTOMER'].freeze

    validates :role, presence: true, inclusion: { in: VALID_ROLES }
    validates :email, presence: true, uniqueness: true

    has_one :customer
    has_many :retailer_orders, class_name: 'CustomerOrder', foreign_key: 'retailer_id'
    has_many :customer_orders, class_name: 'CustomerOrder', foreign_key: 'customer_id'
    
  
    validates :role, presence: true, inclusion: { in: VALID_ROLES }
    validates :email, presence: true, uniqueness: true
    # before_save :ensure_admin_privilege
  
    def self.create_user(params)
      
     
     error = validate_role_and_current_user(params)
     puts "--------------recived error #{error.present?}--------------------"
     return create_new_error(error) if error.present?
      
      user = User.new(
        name: params[:name],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        role: params[:role]
      )
      
      
      if user.save 
        if user.role == "CUSTOMER"
        
          customer = Customer.create(user_id: user.id ,contact: params[:contact], address: params[:address])
        elsif  user.role == "SUPPLIER"
          supplier = Supplier.create(user_id: user.id,contact: params[:contact],notes: "",delivery_time_accuracy: 0.0,order_accuracy: 0.0 )
        end
      end

      user
    end
  
    # private
    def self.validate_role_and_current_user(params)
      # puts "-----------inside validation #{Current.user}-------------------"
     
      if (params[:role] == "SUPPLIER" || params[:role] == "RETAILER") && Current.user&.role != "RETAILER"
          # puts "-----------we can't create ---------------------------"
        return "Must be logged in to create user with role #{params[:role]}"
      end
      # puts "----------------we can create-------------------------"

    end
    def self.create_new_error(error_message)
      user = new
      # puts "-----------creating a new error---------------"
      user.errors.add(:base, error_message)
      user
    end
  
    
  end
  