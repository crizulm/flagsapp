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

ActiveRecord::Schema.define(version: 2018_10_11_190046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "external_users", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "active"
    t.bigint "flags_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flags_id"], name: "index_external_users_on_flags_id"
  end

  create_table "flags", force: :cascade do |t|
    t.string "name"
    t.integer "type"
    t.boolean "active"
    t.integer "percentage"
    t.string "token"
    t.bigint "organizations_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organizations_id"], name: "index_flags_on_organizations_id"
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
    t.integer "total_time"
    t.bigint "flags_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flags_id"], name: "index_reports_on_flags_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "external_users", "flags", column: "flags_id"
  add_foreign_key "flags", "organizations", column: "organizations_id"
  add_foreign_key "reports", "flags", column: "flags_id"
end
