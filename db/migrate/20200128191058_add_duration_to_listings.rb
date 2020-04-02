class AddDurationToListings < ActiveRecord::Migration[6.0]
  def change
    add_column :services, :expiration, :date
    add_column :requests, :expiration, :date
  end
end
