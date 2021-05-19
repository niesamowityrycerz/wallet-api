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

ActiveRecord::Schema.define(version: 2021_05_18_125106) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_enum :debt_statuses, [
    "pending",
    "accepted",
    "rejected",
    "under_scrutiny",
    "closed",
    "corected",
    "settled",
    "expired",
    "anticipated_settlement_date_added",
    "points_alloted",
    "penalty_points_alloted",
  ], force: :cascade

  create_enum :general_debt_statuses, [
    "pending",
    "accepted",
    "rejected",
    "closed",
    "settled",
    "expired",
  ], force: :cascade

  create_enum :group_statuses, [
    "init",
    "terms_added",
    "closed",
  ], force: :cascade

  create_enum :invitation_statuses, [
    "waiting",
    "accepted",
    "rejected",
  ], force: :cascade

  create_table "creditor_ranking_projections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "trust_points", default: 0.0
    t.integer "credits_quantity", default: 0
    t.decimal "ratio", default: "0.0"
    t.string "creditor_name"
    t.integer "creditor_id"
    t.index ["creditor_id"], name: "index_creditor_ranking_projections_on_creditor_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "debt_projections", force: :cascade do |t|
    t.string "debt_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "currency_id"
    t.integer "creditor_id"
    t.integer "debtor_id"
    t.string "description"
    t.date "date_of_transaction"
    t.string "reason_for_closing"
    t.string "doubts"
    t.datetime "date_of_settlement"
    t.float "credibility_points"
    t.float "trust_points"
    t.float "penalty_points", default: 0.0
    t.float "adjusted_credibility_points"
    t.string "reason_for_rejection"
    t.date "anticipated_date_of_settlement"
    t.date "max_date_of_settlement"
    t.string "group_uid"
    t.float "amount"
    t.enum "status", default: "pending", enum_name: "debt_statuses"
  end

  create_table "debt_warning_projections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "warning_type_name"
    t.string "debt_uid"
    t.string "warning_uid"
    t.float "penalty_points"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_debt_warning_projections_on_user_id"
  end

  create_table "debtor_ranking_projections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "adjusted_credibility_points", default: 0.0
    t.integer "debts_quantity", default: 0
    t.decimal "ratio", default: "0.0"
    t.string "debtor_name"
    t.integer "debtor_id"
    t.index ["debtor_id"], name: "index_debtor_ranking_projections_on_debtor_id"
  end

  create_table "debts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "debtor_id"
    t.bigint "creditor_id"
    t.float "amount"
    t.datetime "date_of_transaction"
    t.string "debt_uid"
    t.enum "status", default: "pending", enum_name: "general_debt_statuses"
    t.index ["creditor_id"], name: "index_debts_on_creditor_id"
    t.index ["debtor_id"], name: "index_debts_on_debtor_id"
  end

  create_table "event_store_events", id: :serial, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.string "event_type", null: false
    t.binary "metadata"
    t.binary "data", null: false
    t.datetime "created_at", null: false
    t.datetime "valid_at"
    t.index ["created_at"], name: "index_event_store_events_on_created_at"
    t.index ["event_id"], name: "index_event_store_events_on_event_id", unique: true
    t.index ["event_type"], name: "index_event_store_events_on_event_type"
    t.index ["valid_at"], name: "index_event_store_events_on_valid_at"
  end

  create_table "event_store_events_in_streams", id: :serial, force: :cascade do |t|
    t.string "stream", null: false
    t.integer "position"
    t.uuid "event_id", null: false
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_event_store_events_in_streams_on_created_at"
    t.index ["stream", "event_id"], name: "index_event_store_events_in_streams_on_stream_and_event_id", unique: true
    t.index ["stream", "position"], name: "index_event_store_events_in_streams_on_stream_and_position", unique: true
  end

  create_table "friendships", id: :serial, force: :cascade do |t|
    t.string "friendable_type"
    t.integer "friendable_id"
    t.integer "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "blocker_id"
    t.integer "status"
    t.index ["friendable_id", "friend_id"], name: "index_friendships_on_friendable_id_and_friend_id", unique: true
  end

  create_table "group_members", force: :cascade do |t|
    t.boolean "leader"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id"
    t.bigint "member_id"
    t.string "group_uid"
    t.enum "invitation_status", default: "waiting", enum_name: "invitation_statuses"
    t.index ["group_id"], name: "index_group_members_on_group_id"
    t.index ["member_id"], name: "index_group_members_on_member_id"
  end

  create_table "group_projections", force: :cascade do |t|
    t.string "group_uid"
    t.string "name"
    t.integer "leader_id"
    t.date "from"
    t.date "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "members", array: true
    t.date "debt_repayment_valid_till"
    t.string "currency"
    t.integer "invited_users", array: true
    t.enum "status", default: "init", enum_name: "group_statuses"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.date "from"
    t.date "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_projection_id"
    t.boolean "activated", default: true
    t.index ["group_projection_id"], name: "index_groups_on_group_projection_id"
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "repayment_conditions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "currency_id"
    t.integer "maturity_in_days"
    t.bigint "creditor_id"
    t.index ["creditor_id"], name: "index_repayment_conditions_on_creditor_id"
    t.index ["currency_id"], name: "index_repayment_conditions_on_currency_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "warning_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "warnings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "warning_type_id"
    t.string "debt_uid"
    t.float "penalty_points"
    t.string "warning_uid"
    t.index ["user_id"], name: "index_warnings_on_user_id"
    t.index ["warning_type_id"], name: "index_warnings_on_warning_type_id"
  end

  add_foreign_key "debt_warning_projections", "users"
  add_foreign_key "debts", "users", column: "creditor_id"
  add_foreign_key "debts", "users", column: "debtor_id"
  add_foreign_key "group_members", "groups"
  add_foreign_key "group_members", "users", column: "member_id"
  add_foreign_key "groups", "group_projections"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "posts", "users"
  add_foreign_key "warnings", "users"
end
