class MusicsController < ApplicationController
	def fetch
		music = Music.find( params[ :id ] )
		music[ :url ] = "http://10.141.247.17:3001/music/#{ music[ :id ] }.mp3"
		respond_to do | format |
			format .json { render :json => music }
		end
	end
end
