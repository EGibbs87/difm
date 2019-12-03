class AddSubTypeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sub_type, :string
    add_column :users, :free_posts, :integer, :default => 3
  end
end
