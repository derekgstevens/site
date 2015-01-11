class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

    	t.string :dropbox_token
    	t.string :moves_token
    	t.string :healthgraph_token
    	t.string :jawbone_token

      t.timestamps null: false
    end
  end
end
