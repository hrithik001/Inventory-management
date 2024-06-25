# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_06_25_134520) do
  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_products", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "product_id", null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.integer "supplier_id", null: false
    t.string "signature"
    t.datetime "valid_upto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_contracts_on_supplier_id"
  end

  create_table "customer_order_variants", force: :cascade do |t|
    t.integer "customer_order_id", null: false
    t.integer "variant_id", null: false
    t.integer "ordered_quantity"
    t.integer "supplied_quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_order_id"], name: "index_customer_order_variants_on_customer_order_id"
    t.index ["variant_id"], name: "index_customer_order_variants_on_variant_id"
  end

  create_table "customer_orders", force: :cascade do |t|
    t.datetime "delivery_date"
    t.datetime "order_date"
    t.datetime "expected_delivery_date"
    t.integer "retailer_id"
    t.integer "customer_id"
    t.decimal "total_amount"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "contact"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.integer "variant_id", null: false
    t.integer "user_id", null: false
    t.integer "quantity_available"
    t.integer "minimum_stock_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_inventories_on_user_id"
    t.index ["variant_id"], name: "index_inventories_on_variant_id"
  end

  create_table "inventory_transitions", force: :cascade do |t|
    t.string "transition_type"
    t.integer "quantity"
    t.datetime "transition_date"
    t.integer "variant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "retailer_id", null: false
    t.index ["retailer_id"], name: "index_inventory_transitions_on_retailer_id"
    t.index ["variant_id"], name: "index_inventory_transitions_on_variant_id"
  end

  create_table "jwt_blacklists", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_variants", force: :cascade do |t|
    t.integer "ordered_quantity", null: false
    t.integer "supplied_quantity", default: 0, null: false
    t.integer "order_id", null: false
    t.integer "variant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_variants_on_order_id"
    t.index ["variant_id"], name: "index_order_variants_on_variant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "delivery_date"
    t.datetime "order_date"
    t.datetime "expected_delivery_date"
    t.integer "retailer_id"
    t.integer "supplier_id"
    t.string "status"
    t.decimal "total_amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_categories", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_product_categories_on_category_id"
    t.index ["product_id"], name: "index_product_categories_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "properties", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.integer "variant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["variant_id"], name: "index_properties_on_variant_id"
  end

  create_table "supplier_metrics", force: :cascade do |t|
    t.integer "supplier_id", null: false
    t.decimal "delivery_time_rating", precision: 5, scale: 2, default: "0.0"
    t.decimal "order_accuracy_rating", precision: 5, scale: 2, default: "0.0"
    t.integer "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_supplier_metrics_on_order_id"
    t.index ["supplier_id"], name: "index_supplier_metrics_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "contact"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "delivery_time_accuracy", precision: 5, scale: 2, default: "0.0"
    t.decimal "order_accuracy", precision: 5, scale: 2, default: "0.0"
    t.index ["user_id"], name: "index_suppliers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "variant_prices", force: :cascade do |t|
    t.decimal "base_price", precision: 10, scale: 2
    t.decimal "average_selling_price", precision: 10, scale: 2
    t.decimal "selling_price", precision: 10, scale: 2
    t.integer "variant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["variant_id"], name: "index_variant_prices_on_variant_id"
  end

  create_table "variants", force: :cascade do |t|
    t.integer "price"
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_variants_on_product_id"
  end

  add_foreign_key "contracts", "suppliers"
  add_foreign_key "customer_order_variants", "customer_orders"
  add_foreign_key "customer_order_variants", "variants"
  add_foreign_key "customer_orders", "users", column: "customer_id"
  add_foreign_key "customer_orders", "users", column: "retailer_id"
  add_foreign_key "customers", "users"
  add_foreign_key "inventories", "users"
  add_foreign_key "inventories", "variants"
  add_foreign_key "inventory_transitions", "users", column: "retailer_id"
  add_foreign_key "inventory_transitions", "variants"
  add_foreign_key "order_variants", "orders"
  add_foreign_key "order_variants", "variants"
  add_foreign_key "orders", "users", column: "retailer_id"
  add_foreign_key "orders", "users", column: "supplier_id"
  add_foreign_key "product_categories", "categories"
  add_foreign_key "product_categories", "products"
  add_foreign_key "properties", "variants"
  add_foreign_key "supplier_metrics", "orders"
  add_foreign_key "supplier_metrics", "suppliers"
  add_foreign_key "suppliers", "users"
  add_foreign_key "variants", "products"
end
