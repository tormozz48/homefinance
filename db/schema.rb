# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120610081549) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.float    "amount"
    t.integer  "account_type"
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "enabled",      :default => true, :null => false
  end

  add_index "accounts", ["account_type"], :name => "index_accounts_on_account_type"
  add_index "accounts", ["amount"], :name => "index_accounts_on_amount"
  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "color"
    t.float    "amount"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "enabled",     :default => true, :null => false
  end

  add_index "categories", ["amount"], :name => "index_categories_on_amount"
  add_index "categories", ["user_id"], :name => "index_categories_on_user_id"

  create_table "eating_types", :force => true do |t|
    t.string   "name"
    t.string   "eating_order"
    t.boolean  "enabled"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "eating_types", ["eating_order"], :name => "index_eating_types_on_eating_order"
  add_index "eating_types", ["enabled"], :name => "index_eating_types_on_enabled"

  create_table "eatings", :force => true do |t|
    t.boolean  "enabled"
    t.time     "time"
    t.string   "food"
    t.boolean  "overweight"
    t.integer  "weight_id"
    t.integer  "eating_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "eatings", ["eating_type_id"], :name => "index_eatings_on_eating_type_id"
  add_index "eatings", ["enabled"], :name => "index_eatings_on_enabled"
  add_index "eatings", ["weight_id"], :name => "index_eatings_on_weight_id"

  create_table "transactions", :force => true do |t|
    t.float    "amount"
    t.date     "date"
    t.string   "comment"
    t.integer  "transaction_type"
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "account_from_id"
    t.integer  "account_to_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "enabled",          :default => true, :null => false
  end

  add_index "transactions", ["account_from_id"], :name => "index_transactions_on_account_from_id"
  add_index "transactions", ["account_to_id"], :name => "index_transactions_on_account_to_id"
  add_index "transactions", ["category_id"], :name => "index_transactions_on_category_id"
  add_index "transactions", ["date"], :name => "index_transactions_on_date"
  add_index "transactions", ["transaction_type"], :name => "index_transactions_on_transaction_type"
  add_index "transactions", ["user_id"], :name => "index_transactions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "weights", :force => true do |t|
    t.boolean  "enabled"
    t.float    "weight"
    t.boolean  "training"
    t.date     "date"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "weights", ["date"], :name => "index_weights_on_date"
  add_index "weights", ["enabled"], :name => "index_weights_on_enabled"
  add_index "weights", ["user_id"], :name => "index_weights_on_user_id"

end
