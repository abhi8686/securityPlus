class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :user_1
      t.string :user_2
      t.string :user_1_public
      t.string :user_2_public
      t.timestamps null: false
    end
  end
end
