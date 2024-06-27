class Property < ApplicationRecord
  belongs_to :variant ,dependent: :destroy
  
  def self.ransackable_attributes(auth_object = nil)
    %w[name value]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
