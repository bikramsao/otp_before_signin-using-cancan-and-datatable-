class AddOptToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :otp, :string
  	add_column :users, :otp_confirm, :string
  	add_column :users, :activated, :boolean, default: false

  end
end
