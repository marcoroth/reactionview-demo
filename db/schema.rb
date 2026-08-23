ActiveRecord::Schema[8.1].define(version: 2026_08_23_002345) do
  create_table "messages", force: :cascade do |t|
    t.string "author"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "edited_at"
    t.datetime "sent_at"
    t.datetime "updated_at", null: false
  end
end
