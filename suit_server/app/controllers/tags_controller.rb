class TagsController < ApplicationController
	def fetch
		respond_to do | format |
			format .json { render :json => Tag.random_fetch }
		end
	end
end
