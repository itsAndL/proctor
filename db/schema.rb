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

ActiveRecord::Schema[7.1].define(version: 2024_09_19_102957) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
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

  create_table "assessment_participations", force: :cascade do |t|
    t.bigint "assessment_id", null: false
    t.bigint "temp_candidate_id"
    t.bigint "candidate_id"
    t.integer "status"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "webcam_enabled"
    t.boolean "fullscreen_always_active"
    t.boolean "mouse_always_in_window"
    t.text "notes"
    t.jsonb "devices", default: [], null: false
    t.jsonb "locations", default: [], null: false
    t.jsonb "ips", default: [], null: false
    t.index ["assessment_id", "candidate_id"], name: "index_on_assessment_and_candidate", unique: true
    t.index ["assessment_id", "temp_candidate_id"], name: "index_on_assessment_and_temp_candidate", unique: true
    t.index ["assessment_id"], name: "index_assessment_participations_on_assessment_id"
    t.index ["candidate_id"], name: "index_assessment_participations_on_candidate_id"
    t.index ["temp_candidate_id"], name: "index_assessment_participations_on_temp_candidate_id"
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
    t.datetime "archived_at"
    t.string "public_link_token"
    t.boolean "public_link_active", default: false
    t.index ["business_id"], name: "index_assessments_on_business_id"
    t.index ["public_link_token"], name: "index_assessments_on_public_link_token", unique: true
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

  create_table "custom_question_responses", force: :cascade do |t|
    t.bigint "assessment_participation_id", null: false
    t.bigint "custom_question_id", null: false
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer "status", default: 0
    t.index ["assessment_participation_id", "custom_question_id"], name: "index_custom_question_responses_uniqueness", unique: true
    t.index ["assessment_participation_id"], name: "index_custom_question_responses_on_assessment_participation_id"
    t.index ["custom_question_id"], name: "index_custom_question_responses_on_custom_question_id"
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
    t.bigint "business_id"
    t.integer "language", default: 0
    t.index ["business_id"], name: "index_custom_questions_on_business_id"
    t.index ["custom_question_category_id"], name: "index_custom_questions_on_custom_question_category_id"
    t.index ["language"], name: "index_custom_questions_on_language"
  end

  create_table "options", force: :cascade do |t|
    t.boolean "correct", default: false
    t.string "optionable_type", null: false
    t.bigint "optionable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["optionable_type", "optionable_id"], name: "index_options_on_optionable"
  end

  create_table "participation_tests", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer "status", default: 0
    t.bigint "assessment_participation_id", null: false
    t.bigint "test_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_participation_id", "test_id"], name: "index_participation_tests_on_assessment_participation_and_test", unique: true
    t.index ["assessment_participation_id"], name: "index_participation_tests_on_assessment_participation_id"
    t.index ["test_id"], name: "index_participation_tests_on_test_id"
  end

  create_table "question_answers", force: :cascade do |t|
    t.bigint "assessment_participation_id", null: false
    t.jsonb "content", default: {}, null: false
    t.boolean "is_correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "test_question_id", null: false
    t.index ["assessment_participation_id", "test_question_id"], name: "index_question_answers_on_participation_and_test_question", unique: true
    t.index ["assessment_participation_id"], name: "index_question_answers_on_assessment_participation_id"
    t.index ["content"], name: "index_question_answers_on_content", using: :gin
    t.index ["test_question_id"], name: "index_question_answers_on_test_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.boolean "preview", default: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.boolean "is_correct"
  end

  create_table "screenshots", force: :cascade do |t|
    t.bigint "assessment_participation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_participation_id"], name: "index_screenshots_on_assessment_participation_id"
  end

  create_table "temp_candidates", force: :cascade do |t|
    t.string "name"
    t.citext "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_temp_candidates_on_email", unique: true
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
    t.boolean "active", default: true
    t.bigint "business_id"
    t.integer "language", default: 0
    t.integer "questions_to_answer"
    t.integer "duration_seconds", default: 0, null: false
    t.index ["business_id"], name: "index_tests_on_business_id"
    t.index ["language"], name: "index_tests_on_language"
    t.index ["test_category_id"], name: "index_tests_on_test_category_id"
    t.index ["title"], name: "index_tests_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.citext "email", default: "", null: false
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
  add_foreign_key "assessment_participations", "assessments"
  add_foreign_key "assessment_participations", "candidates"
  add_foreign_key "assessment_participations", "temp_candidates"
  add_foreign_key "assessment_tests", "assessments"
  add_foreign_key "assessment_tests", "tests"
  add_foreign_key "assessments", "businesses"
  add_foreign_key "businesses", "users"
  add_foreign_key "candidates", "users"
  add_foreign_key "custom_question_responses", "assessment_participations"
  add_foreign_key "custom_question_responses", "custom_questions"
  add_foreign_key "custom_questions", "businesses"
  add_foreign_key "custom_questions", "custom_question_categories"
  add_foreign_key "participation_tests", "assessment_participations"
  add_foreign_key "participation_tests", "tests"
  add_foreign_key "question_answers", "assessment_participations"
  add_foreign_key "question_answers", "test_questions"
  add_foreign_key "screenshots", "assessment_participations"
  add_foreign_key "test_questions", "questions"
  add_foreign_key "test_questions", "tests"
  add_foreign_key "tests", "businesses"
  add_foreign_key "tests", "test_categories"
end
