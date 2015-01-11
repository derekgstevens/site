class CreateMonths < ActiveRecord::Migration
  def change
    create_table :months do |t|

    	t.string :name
      t.timestamps null: false
    end

    Month.create name: 'January'
    Month.create name: 'February'
    Month.create name: 'March'
    Month.create name: 'April'
    Month.create name: 'May'
    Month.create name: 'June'
    Month.create name: 'July'
    Month.create name: 'August'
    Month.create name: 'September'
    Month.create name: 'October'
    Month.create name: 'November'
    Month.create name: 'December'
  end
end
