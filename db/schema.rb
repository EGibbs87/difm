# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_06_153108) do

  create_table "classifications", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "classifications_requests", id: false, force: :cascade do |t|
    t.integer "classification_id", null: false
    t.integer "request_id", null: false
    t.index ["classification_id", "request_id"], name: "ix_classification_id_request_id"
  end

  create_table "classifications_services", id: false, force: :cascade do |t|
    t.integer "classification_id", null: false
    t.integer "service_id", null: false
    t.index ["classification_id", "service_id"], name: "ix_classification_id_service_id"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.integer "user_id"
    t.string "digits"
    t.integer "month"
    t.integer "year"
    t.string "stripe_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_credit_cards_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "qty"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "user_id"
    t.string "location"
    t.string "description"
    t.string "timeframe"
    t.float "latitude"
    t.float "longitude"
    t.float "range"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "expiration"
    t.boolean "active", default: true
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.integer "user_id"
    t.string "location"
    t.string "description"
    t.string "availability"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "latitude"
    t.float "longitude"
    t.float "range"
    t.date "expiration"
    t.boolean "active", default: true
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "user_reviews", force: :cascade do |t|
    t.integer "for_user_id", null: false
    t.integer "by_user_id", null: false
    t.string "role"
    t.text "content"
    t.integer "stars"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["by_user_id"], name: "index_user_reviews_on_by_user_id"
    t.index ["for_user_id"], name: "index_user_reviews_on_for_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false
    t.string "phone"
    t.boolean "show_phone_service"
    t.boolean "show_email_service"
    t.boolean "show_phone_request"
    t.boolean "show_email_request"
    t.string "customer_id"
    t.string "sub_type"
    t.text "profile"
    t.string "posts", default: "0"
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
