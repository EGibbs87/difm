class AddFreePosts < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :posts, 4
  end
end
