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

ActiveRecord::Schema[7.1].define(version: 2024_08_09_154937) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
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

  create_table "assessment_custom_questions", force: :cascade do |t|
    t.bigint "assessment_id", null: false
    t.bigint "custom_question_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_assessment_custom_questions_on_assessment_id"
    t.index ["custom_question_id"], name: "index_assessment_custom_questions_on_custom_question_id"
  end

  create_table "assessment_tests", force: :cascade do |t|
    t.bigint "assessment_id", null: false
    t.bigint "test_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_assessment_tests_on_assessment_id"
    t.index ["test_id"], name: "index_assessment_tests_on_test_id"
  end

  create_table "assessments", force: :cascade do |t|
    t.string "title"
    t.integer "language"
    t.bigint "business_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_assessments_on_business_id"
  end

  create_table "businesses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "contact_name"
    t.string "contact_role"
    t.string "company"
    t.text "bio"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_businesses_on_user_id"
  end

  create_table "candidates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_candidates_on_user_id"
  end

  create_table "custom_question_categories", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "custom_questions", force: :cascade do |t|
    t.string "title"
    t.text "relevancy"
    t.text "look_for"
    t.integer "duration_seconds", default: 0
    t.string "type"
    t.integer "position"
    t.bigint "custom_question_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_question_category_id"], name: "index_custom_questions_on_custom_question_category_id"
  end

  create_table "question_options", force: :cascade do |t|
    t.boolean "correct", default: false
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.boolean "preview", default: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration_seconds", default: 0
  end

  create_table "test_categories", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_questions", force: :cascade do |t|
    t.bigint "test_id", null: false
    t.bigint "question_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_test_questions_on_question_id"
    t.index ["test_id"], name: "index_test_questions_on_test_id"
  end

  create_table "tests", force: :cascade do |t|
    t.string "title"
    t.text "overview"
    t.text "description"
    t.integer "level"
    t.json "covered_skills"
    t.text "relevancy"
    t.string "type"
    t.bigint "test_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["test_category_id"], name: "index_tests_on_test_category_id"
    t.index ["title"], name: "index_tests_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assessment_custom_questions", "assessments"
  add_foreign_key "assessment_custom_questions", "custom_questions"
  add_foreign_key "assessment_tests", "assessments"
  add_foreign_key "assessment_tests", "tests"
  add_foreign_key "assessments", "businesses"
  add_foreign_key "businesses", "users"
  add_foreign_key "candidates", "users"
  add_foreign_key "custom_questions", "custom_question_categories"
  add_foreign_key "question_options", "questions"
  add_foreign_key "test_questions", "questions"
  add_foreign_key "test_questions", "tests"
  add_foreign_key "tests", "test_categories"
end
