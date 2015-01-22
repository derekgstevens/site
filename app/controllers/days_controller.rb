class DaysController < ApplicationController
	def index
		@days = Day.last(7)
	end

	def show
		@day = Day.find params[:id]
	end
end
