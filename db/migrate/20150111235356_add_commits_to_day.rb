class AddCommitsToDay < ActiveRecord::Migration
  def change
  	add_column :days, :commits, :text
  end
end
