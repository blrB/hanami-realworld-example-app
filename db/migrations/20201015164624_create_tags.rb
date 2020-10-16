Hanami::Model.migration do
  change do
    create_table :tags do
      primary_key :id

      column :name, String, null: false, size: 64, unique: true

      index :name, unique: true
    end
  end
end
