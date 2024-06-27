class User < ApplicationRecord

    has_secure_password

    VALID_EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/
    VALID_ROLES = ['RETAILER', 'SUPPLIER', 'CUSTOMER'].freeze

    validates :user_name, presence: true, uniqueness: true, on: [:signup, :login]
    validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX, message: "Please enter a valid email address." }
    validates :password, presence: true, length: { minimum: 6 }, on: [:signup, :login]
    validates :role, presence: true, inclusion: { in: VALID_ROLES }
   

    has_one :customer
    has_many :retailer_orders, class_name: 'CustomerOrder', foreign_key: 'retailer_id'
    has_many :customer_orders, class_name: 'CustomerOrder', foreign_key: 'customer_id'
    
  
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
          supplier = Supplier.new(user_id: user.id,contact: params[:contact],notes: "",delivery_time_accuracy: 0.0,order_accuracy: 0.0 )
          if supplier.save
            supplier.create_contract(
              signature: params[:name],
              valid_upto: DateTime.now + 30.days
            )
          else
            return {error: "supplier not created"}
          end
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
   

    def update_profile(params)
      if params[:name]
          self.update(name: params[:name])
      end

      if Current.user.role == "SUPPLIER" 
          supplier = Supplier.find_by(user_id: self.id)
          supplier.update(contact: params[:contact])

      elsif Current.user.role == "CUSTOMER" 
        customer = Customer.find_by(user_id: self.id)
        customer.update(params)

      end
    end
  
    
  end
  