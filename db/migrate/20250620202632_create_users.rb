Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :telegram_id, null: false, unique: true
      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
