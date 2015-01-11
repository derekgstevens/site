class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|

    	t.datetime :day_date
    	t.references :year
    	t.references :month
    	t.integer :min_slept
    	t.string :sleep_title
    	t.integer :sleep_quality
    	t.text :sleep_snapshot_image
    	t.text :step_snapshot_image
    	t.integer :step_total
    	t.integer :active_time
    	t.integer :inactive_time
    	t.text :storyline
    	t.text :reports
    	t.string :run_start
    	t.float :run_total_distance
    	t.integer :run_duration_min
    	t.integer :run_duration_sec

    	t.integer :day_rating
    	t.integer :water_intake



      t.timestamps null: false
    end

    [1..11].each do
    	Day.create()
    end
  end
end
