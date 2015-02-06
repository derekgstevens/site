class HomeController < ApplicationController
	def index
		@day = Day.last
		@storyline = @day.storyline
		#@project = Project.all
	end
end
