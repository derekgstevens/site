class Year < ActiveRecord::Base
	has_many :days

	def self.new_year
		year = Year.create(name: Time.now.year.to_s)
	end
end
