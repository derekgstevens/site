class HomeController < ApplicationController
	def index
		@day = Day.last
		#@project = Project.all
	end
end
