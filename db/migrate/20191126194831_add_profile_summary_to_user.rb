class AddProfileSummaryToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :profile, :text
    add_column :users, :posts, :string, :default => 1
    add_column :users, :username, :string, :unique => true
  end
end
