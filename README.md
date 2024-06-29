# Inventory Management System

Inventory management is a system where stocks of products, supplied by various suppliers, are maintained, and customers can easily access and purchase these products from a single inventory.

## Roles and Their Abilities

### Retailer
The retailer plays a major role in this system. They are responsible for stocking up on products and selling them. The retailer can:
- Add a retailer
- Add a supplier
- Create a product
- Delete a product
- Edit a product
- Add a variant to a product (note: a variant is the same product with different properties, e.g., a t-shirt with size 'M')
- Remove a variant (if the variant has no purchase history)
- Create an order (from a supplier)
- Add ordered product variants to the inventory
- Fulfill customer orders

### Supplier
The supplier is responsible for approving or canceling order requests from the retailer. The supplier can:
- Mark an order as "SHIPPED" or "CANCELLED"
- See Profile details

### Customer
The customer can purchase product variants from the retailer. The customer can:
- Create an order
- See profile
  

## How the Application Works

This application is designed for a single inventory maintained by a retailer. Initially, the retailer adds products to the application and then adds variants to those products, creating a menu for ordering the product variants.

The retailer creates an order by specifying the supplier ID, the product variant ID, and the required quantity. The order is initially created with a status of "PENDING."

When the respective supplier logs in, they can see the pending orders and decide whether to approve or reject them by updating the order status to "SHIPPED" or "CANCELLED."

If the order is approved, the retailer can see the order details, including the total price and the received quantity. If the order is canceled, the metrics (rating) for that particular order will be 0 for the respective supplier.

Once the order is shipped or approved, the retailer adds the items to the inventory by updating the order status to "DELIVERED." This updates the stock in the inventory, and the retailer sets the selling price for the variants with some margin. The supplier receives a rating/metrics based on the order.

After successfully placing and receiving an order, the supplier can see their rating on their profile.

Customers can see the availability of products with details such as name, description, properties, and price, and they can place an order with the specific product variant ID and required quantity. When a customer creates an order, it is initially in a "PENDING" state. Before creating the order, the system checks if the request can be fulfilled. If the customer demands more quantity than available, they will receive a response like "Insufficient quantity." If the order is created successfully, the retailer can see the customer order in the customer order section.

When the retailer logs in, they can see the pending customer orders and approve them by updating the order status to "SHIPPED." Once the status is updated, the inventory transition takes place, and the order's amount is reduced from the inventory.
