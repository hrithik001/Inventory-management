class Api < Grape::API
    
    format :json

    mount Api::V1::Users
    mount Api::V1::Sessions
    mount Api::V1::Orders
    mount Api::V1::Category
    mount Api::V1::Product
    mount Api::V1::Variant
    mount Api::V1::Inventory
    mount Api::V1::CustomerOrder
end
