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

ActiveRecord::Schema.define(version: 2019_09_12_150643) do

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
    t.index ["user_id"], name: "index_services_on_user_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
