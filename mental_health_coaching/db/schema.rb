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

ActiveRecord::Schema.define(version: 2021_11_22_194516) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coach_problems", id: false, force: :cascade do |t|
    t.bigint "coach_id"
    t.bigint "problem_id"
    t.index ["coach_id"], name: "index_coach_problems_on_coach_id"
    t.index ["problem_id"], name: "index_coach_problems_on_problem_id"
  end

  create_table "coaches", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "email"
    t.string "password_digest"
    t.integer "gender"
    t.text "about"
    t.text "avatar"
    t.text "experience"
    t.text "licenses"
    t.text "education"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.text "body"
    t.boolean "status"
    t.bigint "user_id"
    t.bigint "coach_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coach_id"], name: "index_notifications_on_coach_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "social_networks", force: :cascade do |t|
    t.text "name"
    t.bigint "coach_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coach_id"], name: "index_social_networks_on_coach_id"
  end

  create_table "user_problems", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "problem_id"
    t.index ["problem_id"], name: "index_user_problems_on_problem_id"
    t.index ["user_id"], name: "index_user_problems_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "email"
    t.integer "gender"
    t.text "about"
    t.text "avatar"
    t.string "password_digest"
    t.bigint "coach_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coach_id"], name: "index_users_on_coach_id"
  end

  add_foreign_key "notifications", "coaches"
  add_foreign_key "notifications", "users"
  add_foreign_key "social_networks", "coaches"
  add_foreign_key "users", "coaches"
end
