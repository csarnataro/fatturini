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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131202114956) do

  create_table "clients", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "address"
    t.string   "city"
    t.string   "province"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.string   "fiscal_code"
    t.string   "vat_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "salutation"
    t.string   "attention_to"
    t.string   "default_term"
    t.integer  "footer_id"
    t.string   "invoice_language"
    t.string   "default_notes"
  end

  add_index "clients", ["company_id"], name: "index_clients_on_company_id", using: :btree
  add_index "clients", ["footer_id"], name: "index_clients_on_footer_id", using: :btree

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "telephone"
    t.string   "email"
    t.string   "city"
    t.string   "province"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.string   "fiscal_code"
    t.string   "vat_code"
    t.text     "invoice_header"
    t.text     "invoice_footer"
    t.string   "account_holder"
    t.string   "iban"
    t.string   "bank_name"
    t.string   "branch"
    t.string   "bic"
    t.string   "branch_bic"
  end

  create_table "footer_items", force: true do |t|
    t.text    "description"
    t.string  "value"
    t.text    "formula"
    t.integer "footer_id"
    t.string  "default_value"
    t.boolean "summable"
    t.string  "percentage_label"
  end

  add_index "footer_items", ["footer_id"], name: "index_footer_items_on_footer_id", using: :btree

  create_table "footers", force: true do |t|
    t.text "description"
  end

  create_table "invoices", force: true do |t|
    t.text     "notes"
    t.text     "term"
    t.string   "status"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "creation_date"
    t.date     "invoice_date"
    t.date     "payment_date"
    t.string   "number"
    t.integer  "footer_id"
  end

  add_index "invoices", ["client_id"], name: "index_invoices_on_client_id", using: :btree
  add_index "invoices", ["footer_id"], name: "index_invoices_on_footer_id", using: :btree

  create_table "items", force: true do |t|
    t.integer  "invoice_id"
    t.text     "description"
    t.decimal  "unit_cost",   precision: 8,  scale: 3
    t.decimal  "quantity",    precision: 10, scale: 0
    t.decimal  "discount",    precision: 5,  scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "total",       precision: 8,  scale: 3
  end

  add_index "items", ["invoice_id"], name: "index_items_on_invoice_id", using: :btree

  create_table "memos", force: true do |t|
    t.string   "vendor"
    t.string   "goods"
    t.decimal  "amount",        precision: 10, scale: 0
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "creation_date"
  end

  add_index "memos", ["company_id"], name: "index_memos_on_company_id", using: :btree

  create_table "services", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "uname"
    t.string   "uemail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.integer "company_id"
    t.string  "email"
    t.string  "user_type"
    t.string  "name"
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree

end
