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

ActiveRecord::Schema.define(version: 20150226104146) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "section_id"
  end

  add_index "categories", ["name", "section_id"], name: "index_categories_on_name_and_section_id", unique: true

  create_table "links", force: true do |t|
    t.string   "url"
    t.text     "description"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",   default: true
  end

  add_index "links", ["category_id", "created_at"], name: "index_links_on_category_id_and_created_at"
  add_index "links", ["url", "category_id"], name: "index_links_on_url_and_category_id", unique: true

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",   default: true
    t.text     "preview"
  end

  add_index "posts", ["title", "category_id"], name: "index_posts_on_title_and_category_id", unique: true

  create_table "sections", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sections", ["name"], name: "index_sections_on_name", unique: true

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
