class CreateUserReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :user_reviews do |t|
      t.references :for_user, null: false, foreign_key: false
      t.references :by_user, null: false, foreign_key: false
      t.string :role
      t.text :content
      t.integer :stars

      t.timestamps
    end
  end
end
