class User < ActiveRecord::Base
	# attr_accessible :title, :body
	class << self 
		def initial_account
			user = User .create()
			Music.find( :all ) .each do | music |
				Score.create( :user_id => user[ :id ] , :music_id => music[ :id ] ) #=> now music id is i
			end

			user
		end
	end
end
