class CreateCreditCards < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_cards do |t|
      t.belongs_to :user

      t.string :digits
      t.integer :month
      t.integer :year
      t.string :stripe_id

      t.timestamps
    end

    add_column :users, :customer_id, :string
  end
end
