# README



*Project Name = "Inventory management system"

Inventory management is basically where we'll keep stocks of products, which is supplied by many supplier's ,And customer can get easy access of buying products for a place( This is only one Inventory )

* Roles and there abilities

* Retailer
  
  This role playes the majore role here , he is the one who need to stock up the things and sell

  -> can add retailer 
  -> can add a supplier
  -> can create a product
  -> can delete a product
  -> can edit a product
  -> can add variant to a product (note: variant is same product with different properties e.g: if t-shirt is a product then 
                                        the variant for that is t-shirt with size 'M' )
  -> can remove a variant ( if that variant is not having any purchase histroy )
  -> can create a order ( from supplier )
  -> can add ordered product variants to inventory
  -> can fullfill the customer order's

* Supplier
    
    This role is for either approved the request of order or cancelled the order request

    -> can "SHIPPED" or "CANCELLED" the order by retailer

* Customer

    This role can buy the products vairiants from Retailer

    -> can create a order


* Working of appplication

This application is made for single Inventory which can be maintain retailer , initially we'll have a retailer , who will add product to the application and after that add variants to a product , this works like a menu for ordering the product variants,
Retailer will create a order by specifiying the supplier id and the product variant id and the quantity that they required , 
Initially the order will get created with order status "PENDING" 

When the respective Supplier will logged in , they can see the PENDING order's there, and they can specify that either they will reject or approved the order by updating order status to "CANCELLED" or "SHIPPED" , 

If Order got approved retailer can see the order details like Total price for that order and the recived quantity
or if order got cancelled then the metrices ( rating ) for that particular order will be 0 for respective supplier

Order shipped / approved to retailer , now they should add that to inventory , when retailer will update the order status as a "DELIVERED" then the inventory transistion will take place , and that keep the stocks in Inventory , and they will fix the sellign price for that variants with some margin , and rating / matrices will be given to the supplier 

After successfuly Order placed and recived by retailer, Supplier can see there rating to there profiles

Now Customer can see the avilabilty of the products with there details such as name , description, its properties , price , and they can place a order with the specific product variant id and required quantity, When the customer creates the order it is Initially at PENDING state , before creating we're checking weather we can fullfill the request or not , suppose knowingly if the customer demanded more quantity than our stock then we'll have a response like , "Insufficient quantity",If order is created sucessfully then retailer can see the customer order in customer order section

When Retailer will logged In, they can see the the PENDING order from customer and they can approved there orders by updating the order status as "SHIPPED" , when status will get updated then the Inventory transisition will take place and the order's amount will be reduced form Inventory
  