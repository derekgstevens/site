class HomeController < ApplicationController
	def index
		@days = Day.last(2)
		@day = @days.first
		#@project = Project.all
	end
end
