class DaysController < ApplicationController
	def index
		@days = Day.last(7)
	end

	def show
		@day = Day.find params[:id]
	end

	def storyline
		respond_to do |format|
			format.json {
				render :json => Day.last.storyline
			}
	end
end
