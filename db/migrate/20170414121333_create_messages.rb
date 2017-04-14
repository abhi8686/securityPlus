class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :conversation, index: true
      t.string :content
      t.string :sender_id
      t.string :recevier_id
      t.timestamps null: false
    end
  end
end
