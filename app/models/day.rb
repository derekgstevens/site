class Day < ActiveRecord::Base
	require 'dropbox_sdk'

	belongs_to :year
	belongs_to :month

	serialize :storyline
	serialize :reports
	serialize :commits

	def prepare_storyline
		user = User.first
		base_url = 'https://api.foursqure.com/v2/'
		conn = Faraday.new(:url => "https://api.foursquare.com/v2/") do |faraday|
			faraday.request :url_encoded
			faraday.response :logger
			faraday.adapter Faraday.default_adapter
		end

		timeline = Array.new
		self.storyline.each do |story|
			element = Hash.new
			element[:type] = story["type"]
			if story["startTime"].in_time_zone.day != self.day_date.day
				element[:startTime] = self.day_date.beginning_of_day
			else 
				element[:startTime] = story["startTime"].in_time_zone
			end
			if story["endTime"].in_time_zone.day != self.day_date.day
				element[:endTime] = self.day_date.end_of_day
			else
				element[:endTime] = story["endTime"].in_time_zone
			end
			element[:width] = calculate_width(element[:startTime], element[:endTime])

			if element[:type] == "place"
				place = story["place"].values
				element[:name] = place[1]
				if element[:name] != "Home"
					venue_id = place[3]
					url = "venues/#{venue_id}?" + {client_id: user.foursquare_id, client_secret: user.foursquare_secret, m: 'foursquare', v: '20150101' }.to_query
					response = conn.get url
					venue = JSON.load(response.body)
					element[:venue_location] = venue["response"]["venue"]["location"]
					#element[:venue_icon] = venue["response"]["venue"]["categories"]
					icon = venue["response"]["venue"]["categories"].first["icon"]
					element[:venue_icon] = icon["prefix"] + "32" + icon["suffix"]
				else
					element[:venue_icon] = "https://ss3.4sqi.net/img/categories_v2/building/home_64.png"
				end
			elsif element[:type] == "move"
				activities = story["activities"]
			else
			end
			timeline << element
		end
		timeline
	end

	def calculate_width(startTime, endTime)
		seconds_in_day = 86400
		duration = ((endTime - startTime) / seconds_in_day) * 100
	end

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

	def self.github
		day = Day.last
		day_date = day.day_date.strftime("%Y-%m-%d")
		todays_commits = day.commits
		commit_count = 0
		commits_to_add = ""

		repos = ['ulti-team', 'site']

		repos.each do |repo|

			all_commits = Github.repos.commits.all 'dstevens-cs', repo

			puts "------------------"
			all_commits.each do |c|
				puts c["commit"]["author"]["date"].in_time_zone
				if c["commit"]["author"]["date"].in_time_zone.strftime("%Y-%m-%d") == day_date
					if todays_commits !~ /c["sha"]/
						commit = {:commit_time => c["commit"]["author"]["date"].in_time_zone.strftime("%H:%M:%S"),
											:sha => c["sha"],
											:html_url => c["html_url"],
											:message => c["commit"]["message"]
										 }

						commits_to_add = commits_to_add + commit.to_s
					end
				end
			end

			todays_commits = todays_commits.to_s + commits_to_add
			day.commits = todays_commits
		end
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
