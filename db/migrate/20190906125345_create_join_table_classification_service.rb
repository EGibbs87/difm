class CreateJoinTableClassificationService < ActiveRecord::Migration[6.0]
  def change
    create_join_table :classifications, :services do |t|
      t.index [:classification_id, :service_id], :name => :ix_classification_id_service_id
    end
  end
end
