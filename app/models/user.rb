class User < ApplicationRecord
    has_secure_password
    VALID_ROLES = ['RETAILER', 'SUPPLIER', 'CUSTOMER'].freeze
  
    validates :role, presence: true, inclusion: { in: VALID_ROLES }
    validates :email, presence: true, uniqueness: true
    # before_save :ensure_admin_privilege
  
    def self.create_user(params)
      user = User.new(
        name: params[:name],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        role: params[:role]
      )
      
      user.save # Save the user to persist in the database
      user
    end
  
    private
  
    # def ensure_admin_privilege
    #   # Define the logic to ensure admin privileges if needed
    # end
  end
  