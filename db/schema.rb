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

ActiveRecord::Schema[8.0].define(version: 2026_04_18_120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "case_applications", force: :cascade do |t|
    t.string "name"
    t.string "telegram"
    t.string "company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "other_contact"
  end

  create_table "case_resources", force: :cascade do |t|
    t.bigint "case_id", null: false
    t.bigint "resource_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_case_resources_on_case_id"
    t.index ["resource_id"], name: "index_case_resources_on_resource_id"
  end

  create_table "cases", force: :cascade do |t|
    t.string "company"
    t.string "ds_name"
    t.string "tags"
    t.string "accent_color"
    t.text "tldr"
    t.text "context"
    t.text "positioning"
    t.text "composition"
    t.text "processes"
    t.text "documentation"
    t.text "design_code_sync"
    t.text "quality"
    t.text "scaling"
    t.text "unique_practices"
    t.text "conclusions"
    t.text "quotes"
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "industry"
    t.string "case_type"
    t.string "company_type"
    t.string "materials"
    t.string "case_format"
    t.string "card_title"
    t.text "focus_description"
    t.text "speaker_role"
    t.text "artifacts"
    t.text "intro"
  end

  create_table "resources", force: :cascade do |t|
    t.string "resource_type"
    t.string "tags"
    t.string "title"
    t.text "description"
    t.string "url"
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "term_cases", force: :cascade do |t|
    t.bigint "term_id", null: false
    t.bigint "case_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["case_id"], name: "index_term_cases_on_case_id"
    t.index ["term_id", "case_id"], name: "index_term_cases_on_term_id_and_case_id", unique: true
    t.index ["term_id"], name: "index_term_cases_on_term_id"
  end

  create_table "terms", force: :cascade do |t|
    t.string "term"
    t.text "definition"
    t.string "category"
    t.string "sources"
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "purpose"
    t.text "context"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "case_resources", "cases"
  add_foreign_key "case_resources", "resources"
  add_foreign_key "term_cases", "cases"
  add_foreign_key "term_cases", "terms"
end
