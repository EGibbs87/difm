class RemoveFreePosts < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :free_posts, :string
  end
end
