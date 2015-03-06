class AddFoursqureToUser < ActiveRecord::Migration
  def change
  	add_column :users, :foursquare_id, :string
  	add_column :users, :foursquare_secret, :string
  end
end
