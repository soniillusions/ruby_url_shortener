Sequel.migration do
  change do
    create_table(:user_links) do
      foreign_key :user_id, :users, null: false, on_delete: :cascade
      foreign_key :link_id, :links, null: false, on_delete: :cascade
      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      primary_key [:user_id, :link_id]
    end
  end
end
