class CreateServices < ActiveRecord::Migration[6.0]
  def change
    create_table :services do |t|
      t.belongs_to :user

      t.string :location
      t.string :description
      t.string :availability

      t.timestamps
    end
  end
end
