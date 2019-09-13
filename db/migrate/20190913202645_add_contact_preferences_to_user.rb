class AddContactPreferencesToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :phone, :string
    add_column :users, :show_phone_service, :boolean
    add_column :users, :show_email_service, :boolean
    add_column :users, :show_phone_request, :boolean
    add_column :users, :show_email_request, :boolean
  end
end
