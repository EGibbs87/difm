class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.belongs_to :user

      t.string :location
      t.string :description
      t.string :timeframe
      t.float :latitude
      t.float :longitude
      t.float :range

      t.timestamps
    end

    create_join_table :classifications, :requests do |t|
      t.index [:classification_id, :request_id], :name => :ix_classification_id_request_id
    end
  end
end
