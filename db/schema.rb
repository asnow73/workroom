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

ActiveRecord::Schema.define(version: 20131004173836) do

  create_table "books", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_url"
    t.string   "source_url"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "books", ["name", "category_id"], name: "index_books_on_name_and_category_id", unique: true

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
  end

  add_index "links", ["category_id", "created_at"], name: "index_links_on_category_id_and_created_at"
  add_index "links", ["url", "category_id"], name: "index_links_on_url_and_category_id", unique: true

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["title", "category_id"], name: "index_posts_on_title_and_category_id", unique: true

  create_table "sections", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sections", ["name"], name: "index_sections_on_name", unique: true

end
