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

ActiveRecord::Schema.define(version: 2021_05_09_101917) do

  create_table "creditors_ranking", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "trust_points", default: 0.0
    t.integer "credits_quantity", default: 0
    t.decimal "ratio", precision: 2, scale: 2
    t.string "creditor_name"
    t.integer "creditor_id"
    t.index ["creditor_id"], name: "index_creditors_ranking_on_creditor_id"
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
    t.integer "status", default: 0
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
  end

  create_table "debt_warning_projections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "warning_type_name"
    t.string "debt_uid"
    t.string "warning_uid"
    t.float "penalty_points"
    t.integer "user_id"
    t.index ["user_id"], name: "index_debt_warning_projections_on_user_id"
  end

  create_table "debtors_ranking", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "adjusted_credibility_points", default: 0.0
    t.integer "debts_quantity", default: 0
    t.decimal "ratio", precision: 2, scale: 2
    t.string "debtor_name"
    t.integer "debtor_id"
    t.index ["debtor_id"], name: "index_debtors_ranking_on_debtor_id"
  end

  create_table "debts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "debtor_id"
    t.integer "creditor_id"
    t.float "amount"
    t.string "debt_uid"
    t.datetime "date_of_transaction"
    t.integer "state", default: 0
    t.index ["creditor_id"], name: "index_debts_on_creditor_id"
    t.index ["debt_uid"], name: "index_debts_on_debt_uid"
    t.index ["debtor_id"], name: "index_debts_on_debtor_id"
  end

  create_table "event_store_events", force: :cascade do |t|
    t.string "event_id", limit: 36, null: false
    t.string "event_type", null: false
    t.binary "metadata"
    t.binary "data", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "valid_at", precision: 6
    t.index ["created_at"], name: "index_event_store_events_on_created_at"
    t.index ["event_id"], name: "index_event_store_events_on_event_id", unique: true
    t.index ["event_type"], name: "index_event_store_events_on_event_type"
    t.index ["valid_at"], name: "index_event_store_events_on_valid_at"
  end

  create_table "event_store_events_in_streams", force: :cascade do |t|
    t.string "stream", null: false
    t.integer "position"
    t.string "event_id", limit: 36, null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["created_at"], name: "index_event_store_events_in_streams_on_created_at"
    t.index ["stream", "event_id"], name: "index_event_store_events_in_streams_on_stream_and_event_id", unique: true
    t.index ["stream", "position"], name: "index_event_store_events_in_streams_on_stream_and_position", unique: true
  end

  create_table "friendships", force: :cascade do |t|
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
    t.boolean "founder"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
    t.integer "member_id"
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
    t.string "members"
    t.date "debt_repayment_valid_till"
    t.string "currency"
    t.integer "state"
    t.string "invited_users"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.date "from"
    t.date "to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id", null: false
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

  create_table "repayment_conditions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "currency_id"
    t.integer "maturity_in_days"
    t.integer "creditor_id"
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
    t.integer "user_id"
    t.integer "warning_type_id"
    t.string "debt_uid"
    t.float "penalty_points"
    t.string "warning_uid"
    t.index ["user_id"], name: "index_warnings_on_user_id"
    t.index ["warning_type_id"], name: "index_warnings_on_warning_type_id"
  end

end
