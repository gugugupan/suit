class UsersController < ApplicationController
	def create
		user = User.initial_account()

		respond_to do | format |
			format .json { render :json => user }
		end
	end

	def feedback
		return if params[ :id ] .nil?
		Music.feedback( params[ :id ] , params[ :music_id ] , params[ :score ] .to_f )

		respond_to do | format |
			format .json { render :json => nil? }
		end
	end

	def fetch_music
		return if params[ :id ] .nil?
		music = Music.best_select( params[ :id ] )
		History.add_history( params[ :id ] , music[ :id ] )
		#music = Music .find( 1590 )
		music[ :url ] = "http://10.141.247.17:3001/music/#{ music[ :id ] }.mp3"

		respond_to do | format |
			format .json { render :json => music }
		end
	end

	def fetch
		return if params[ :id ] .nil?
		respond_to do | format |
			format .json { render :json => User.fetch( params[ :id ] ) }
		end
	end
end
