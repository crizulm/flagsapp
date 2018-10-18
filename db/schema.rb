# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_18_153411) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "external_users", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "active"
    t.bigint "flag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flag_id"], name: "index_external_users_on_flag_id"
  end

  create_table "flag_records", force: :cascade do |t|
    t.bigint "flag_id"
    t.date "date_start"
    t.date "date_end"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flag_id"], name: "index_flag_records_on_flag_id"
  end

  create_table "flags", force: :cascade do |t|
    t.string "name"
    t.integer "style_flag"
    t.boolean "active", default: true
    t.datetime "last_update"
    t.boolean "is_deleted", default: false
    t.integer "percentage"
    t.string "auth_token"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_flags_on_organization_id"
  end

  create_table "invites", force: :cascade do |t|
    t.string "email"
    t.integer "sender_id"
    t.integer "organization_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer "total_request"
    t.integer "true_answer"
    t.integer "false_answer"
    t.integer "new_request"
    t.integer "new_true_answer"
    t.decimal "total_time"
    t.bigint "flag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flag_id"], name: "index_reports_on_flag_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.string "surname", default: "", null: false
    t.boolean "is_admin", default: false, null: false
    t.string "picture"
    t.bigint "organization_id"
    t.string "provider"
    t.string "uid"
    t.string "image"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  add_foreign_key "external_users", "flags"
  add_foreign_key "flags", "organizations"
end
