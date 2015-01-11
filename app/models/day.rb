class Day < ActiveRecord::Base
	require 'dropbox_sdk'

	belongs_to :year
	belongs_to :month

	serialize :storyline
	serialize :reports

	def self.new_day
		day = Day.new(day_date: Time.now)
		month = Month.find(Time.now.month)
		if month.id == 1 && Time.now.day == 1
			Year.new_year
		end
		year = Year.where("name = ?", Time.now.year.to_s).first

		day.year_id = year.id
		day.month_id = month.id 

		day.save
	end

		def self.reporter
		day = Day.last
		day_date = day.day_date.strftime("%Y-%m-%d")

		reporterclient = DropboxClient.new(User.first.dropbox_token)
		content = reporterclient.get_file("Apps/Reporter-App/#{day_date}-reporter-export.json")
		day.reports = JSON.parse content
		day.save
	end

	def self.runkeeper
		rkclient = HealthGraph::User.new(User.first.healthgraph_token)

		@day = Day.last
		day_date = @day.day_date.strftime("%Y-%m-%d")

		fitness_activity = rkclient.fitness_activities.items[0]

		start_time = fitness_activity["start_time"]
		activity_date = Date.parse start_time
		activity_time = Time.parse start_time
		activity_date = activity_date.strftime("%Y-%m-%d")

		if day_date == activity_date
			@day.run_start = activity_time.strftime("%H:%M:%S")
			@day.run_duration_min = (fitness_activity["duration"] / 60).to_i 
			@day.run_duration_sec = (fitness_activity["duration"] % 60).to_i 
			@day.run_total_distance = '%.2f' % (fitness_activity["total_distance"] * 0.00062137)
			@day.save
		end
	end

	def self.moves
		movesclient = Moves::Client.new User.first.moves_token

		@day = Day.last
		day_date = @day.day_date.strftime("%Y-%m-%d")

		result = movesclient.daily_storyline(day_date)
		@day.storyline = result[0]["segments"]
		@day.save
	end

	def self.jawbone
		jawboneclient = Jawbone::Client.new User.first.jawbone_token
		days = Day.last(2)
		@day = days[1]
		@day_before = days[0]
		if(@day.day_date.strftime("%Y%m%d").to_s == jawboneclient.moves["data"]["items"][0]["date"].to_s)
			@day.sleep_title = jawboneclient.sleeps["data"]["items"][0]["title"]
			@day.sleep_quality = jawboneclient.sleeps["data"]["items"][0]["details"]["quality"]
			@day.min_slept = jawboneclient.sleeps["data"]["items"][0]["details"]["duration"]
			@day.sleep_snapshot_image = jawboneclient.sleeps["data"]["items"][0]["snapshot_image"]
			
			@day.step_snapshot_image = jawboneclient.moves["data"]["items"][0]["snapshot_image"]
			@day.step_total = jawboneclient.moves["data"]["items"][0]["details"]["steps"]
			@day.active_time = jawboneclient.moves["data"]["items"][0]["details"]["active_time"]
			@day.inactive_time = jawboneclient.moves["data"]["items"][0]["details"]["inactive_time"]
			@day.save

			if(@day_before.step_total != jawboneclient.moves["data"]["items"][1]["details"]["steps"])
				@day_before.sleep_title = jawboneclient.sleeps["data"]["items"][1]["title"]
				@day_before.sleep_quality = jawboneclient.sleeps["data"]["items"][1]["details"]["quality"]
				@day_before.min_slept = jawboneclient.sleeps["data"]["items"][1]["details"]["duration"]
				@day_before.sleep_snapshot_image = jawboneclient.sleeps["data"]["items"][1]["snapshot_image"]
				
				@day_before.step_snapshot_image = jawboneclient.moves["data"]["items"][1]["snapshot_image"]
				@day_before.step_total = jawboneclient.moves["data"]["items"][1]["details"]["steps"]
				@day_before.active_time = jawboneclient.moves["data"]["items"][1]["details"]["active_time"]
				@day_before.inactive_time = jawboneclient.moves["data"]["items"][1]["details"]["inactive_time"]
				@day_before.save
			end
		end
	end
end