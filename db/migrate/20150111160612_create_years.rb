class CreateYears < ActiveRecord::Migration
  def change
    create_table :years do |t|

    	t.string :name
      t.timestamps null: false
    end

    Year.create name: '2015'
  end
end
