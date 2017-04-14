class CreateGlobalKeys < ActiveRecord::Migration
  def change
    create_table :global_keys do |t|
      t.belongs_to :user, index: true
      t.text :public_key
      t.timestamps null: false
    end
  end
end
