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

ActiveRecord::Schema[8.1].define(version: 2025_12_30_212359) do
  create_table "configuration_active_worlds", force: :cascade do |t|
    t.integer "configuration_id", null: false
    t.datetime "created_at", null: false
    t.string "hostname", null: false
    t.datetime "updated_at", null: false
    t.integer "world_id", null: false
    t.index ["configuration_id"], name: "index_configuration_active_worlds_on_configuration_id"
    t.index ["world_id"], name: "index_configuration_active_worlds_on_world_id"
  end

  create_table "configuration_activities", force: :cascade do |t|
    t.string "action", null: false
    t.integer "configuration_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["configuration_id"], name: "index_configuration_activities_on_configuration_id"
    t.index ["user_id"], name: "index_configuration_activities_on_user_id"
  end

  create_table "configurations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "parent_id"
    t.string "state", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_configurations_on_parent_id"
  end

  create_table "minecraft_worlds", force: :cascade do |t|
    t.string "backend_addr", null: false
    t.datetime "created_at", null: false
    t.string "display_name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "sessions", "users"
end
