# This file is auto-generated from the current state of the database. Instead of editing this file,
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails db:schema:load`.
# If you need to create the application database on another system, you should be using `rails db:schema:load`,
# not running all the migrations from scratch. The latter is a flawed and error-prone approach and should be
# avoided.
#
# It's strongly recommended that you use this approach to populate schema.rb. You may
# prefer to use one of the alternatives and run migrations instead:
#
#   rails db:schema:load_or_migrations might not be db:schema:load & db:migrate

ActiveRecord::Schema[7.0].define(version: 2024_01_01_000012) do
  # These are extensions that must be enabled on PostgreSQL databases
  enable_extension "plpgsql"

  create_table "currencies", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.boolean "is_crypto", default: false
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_currencies_on_code", unique: true
  end

  create_table "crypto_prices", force: :cascade do |t|
    t.bigint "currency_id", null: false
    t.decimal "price", precision: 20, scale: 8, null: false
    t.decimal "market_cap", precision: 25, scale: 2
    t.decimal "volume_24h", precision: 25, scale: 2
    t.decimal "change_24h", precision: 10, scale: 4
    t.datetime "fetched_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id", "fetched_at"], name: "index_crypto_prices_on_currency_id_and_fetched_at"
    t.foreign_key "currencies", column: "currency_id"
  end

  create_table "deposits", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "wallet_id", null: false
    t.decimal "amount", precision: 20, scale: 8, null: false
    t.integer "status", default: 0
    t.string "razorpay_order_id"
    t.string "razorpay_payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["razorpay_payment_id"], name: "index_deposits_on_razorpay_payment_id", unique: true
    t.index ["user_id", "created_at"], name: "index_deposits_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_deposits_on_user_id"
    t.index ["wallet_id"], name: "index_deposits_on_wallet_id"
    t.foreign_key "users", column: "user_id"
    t.foreign_key "wallets", column: "wallet_id"
  end

  create_table "kycs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status", default: 0
    t.datetime "approved_at"
    t.datetime "rejected_at"
    t.text "rejection_reason"
    t.bigint "approved_by_id"
    t.bigint "rejected_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_kycs_on_approved_by_id"
    t.index ["rejected_by_id"], name: "index_kycs_on_rejected_by_id"
    t.index ["user_id"], name: "index_kycs_on_user_id", unique: true
    t.foreign_key "users", column: "user_id"
    t.foreign_key "users", column: "approved_by_id"
    t.foreign_key "users", column: "rejected_by_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "trading_pair_id", null: false
    t.integer "order_type", null: false
    t.decimal "quantity", precision: 20, scale: 8, null: false
    t.decimal "price", precision: 20, scale: 8, null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trading_pair_id"], name: "index_orders_on_trading_pair_id"
    t.index ["user_id", "created_at"], name: "index_orders_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_orders_on_user_id"
    t.foreign_key "trading_pairs", column: "trading_pair_id"
    t.foreign_key "users", column: "user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "phone_number"
    t.date "date_of_birth"
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_number"], name: "index_profiles_on_phone_number", unique: true
    t.index ["user_id"], name: "index_profiles_on_user_id"
    t.foreign_key "users", column: "user_id"
  end

  create_table "trading_pairs", force: :cascade do |t|
    t.bigint "base_currency_id", null: false
    t.bigint "quote_currency_id", null: false
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["base_currency_id", "quote_currency_id"], name: "index_trading_pairs_on_base_and_quote_currency", unique: true
    t.index ["base_currency_id"], name: "index_trading_pairs_on_base_currency_id"
    t.index ["quote_currency_id"], name: "index_trading_pairs_on_quote_currency_id"
    t.foreign_key "currencies", column: "base_currency_id"
    t.foreign_key "currencies", column: "quote_currency_id"
  end

  create_table "trades", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "order_id", null: false
    t.bigint "trading_pair_id", null: false
    t.integer "trade_type", null: false
    t.decimal "quantity", precision: 20, scale: 8, null: false
    t.decimal "price", precision: 20, scale: 8, null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_trades_on_order_id"
    t.index ["trading_pair_id"], name: "index_trades_on_trading_pair_id"
    t.index ["user_id", "created_at"], name: "index_trades_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_trades_on_user_id"
    t.foreign_key "orders", column: "order_id"
    t.foreign_key "trading_pairs", column: "trading_pair_id"
    t.foreign_key "users", column: "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wallet_ledgers", force: :cascade do |t|
    t.bigint "wallet_id", null: false
    t.integer "transaction_type", null: false
    t.decimal "amount", precision: 20, scale: 8, null: false
    t.decimal "balance_after", precision: 20, scale: 8, null: false
    t.string "description"
    t.bigint "trade_id"
    t.bigint "deposit_id"
    t.bigint "withdrawal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_wallet_ledgers_on_created_at"
    t.index ["deposit_id"], name: "index_wallet_ledgers_on_deposit_id"
    t.index ["trade_id"], name: "index_wallet_ledgers_on_trade_id"
    t.index ["wallet_id"], name: "index_wallet_ledgers_on_wallet_id"
    t.index ["withdrawal_id"], name: "index_wallet_ledgers_on_withdrawal_id"
    t.foreign_key "deposits", column: "deposit_id"
    t.foreign_key "trades", column: "trade_id"
    t.foreign_key "wallets", column: "wallet_id"
    t.foreign_key "withdrawals", column: "withdrawal_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "currency_id", null: false
    t.decimal "balance", precision: 20, scale: 8, default: "0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_wallets_on_currency_id"
    t.index ["user_id", "currency_id"], name: "index_wallets_on_user_id_and_currency_id", unique: true
    t.index ["user_id"], name: "index_wallets_on_user_id"
    t.foreign_key "currencies", column: "currency_id"
    t.foreign_key "users", column: "user_id"
  end

  create_table "withdrawals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "wallet_id", null: false
    t.decimal "amount", precision: 20, scale: 8, null: false
    t.integer "status", default: 0
    t.string "wallet_address", null: false
    t.string "blockchain_transaction_hash"
    t.text "rejection_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_withdrawals_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_withdrawals_on_user_id"
    t.index ["wallet_id"], name: "index_withdrawals_on_wallet_id"
    t.foreign_key "users", column: "user_id"
    t.foreign_key "wallets", column: "wallet_id"
  end
end
