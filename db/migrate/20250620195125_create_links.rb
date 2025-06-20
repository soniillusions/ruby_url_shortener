Sequel.migration do
  change do
    create_table?(:links) do
      primary_key :id
      Text :original_url, null: false, unique: true
      String :short_url, null: false, unique: true
      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
