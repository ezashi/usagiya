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

ActiveRecord::Schema[8.0].define(version: 2025_12_31_033439) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "login_id"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login_id"], name: "index_admin_users_on_login_id", unique: true
  end

  create_table "calendar_events", force: :cascade do |t|
    t.integer "event_type"
    t.date "event_date"
    t.text "description"
    t.boolean "auto_notice", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "color"
  end

  create_table "inquiries", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notices", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.string "draft_title"
    t.datetime "draft_saved_at"
    t.text "draft_content"
    t.index ["draft_saved_at"], name: "index_notices_on_draft_saved_at"
    t.index ["published"], name: "index_notices_on_published"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "product_type"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "customer_name"
    t.string "postal_code"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.string "delivery_name"
    t.string "delivery_postal_code"
    t.string "delivery_address"
    t.string "delivery_phone"
    t.boolean "same_address"
    t.integer "payment_method"
    t.date "delivery_date"
    t.string "delivery_time"
    t.string "wrapping_type"
    t.text "notes"
    t.integer "total_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "products"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.text "description"
    t.boolean "featured", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_filename", default: "", null: false
    t.string "category"
    t.boolean "visible", default: true
    t.integer "display_order", default: 0
    t.boolean "seasonal", default: false
    t.integer "featured_order"
    t.integer "seasonal_order"
    t.datetime "published_at"
    t.datetime "draft_saved_at"
    t.string "draft_name"
    t.integer "draft_price"
    t.text "draft_description"
    t.boolean "draft_featured", default: false
    t.boolean "draft_seasonal", default: false
    t.integer "draft_featured_order"
    t.integer "draft_seasonal_order"
    t.index ["category"], name: "index_products_on_category"
    t.index ["display_order"], name: "index_products_on_display_order"
    t.index ["draft_featured_order"], name: "index_products_on_draft_featured_order"
    t.index ["draft_saved_at"], name: "index_products_on_draft_saved_at"
    t.index ["draft_seasonal_order"], name: "index_products_on_draft_seasonal_order"
    t.index ["featured"], name: "index_products_on_featured"
    t.index ["featured_order"], name: "index_products_on_featured_order"
    t.index ["seasonal"], name: "index_products_on_seasonal"
    t.index ["seasonal_order"], name: "index_products_on_seasonal_order"
    t.index ["visible"], name: "index_products_on_visible"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "order_items", "orders"
end
