class User < ActiveRecord::Base
	# attr_accessible :title, :body
	class << self 
		def fetch( id )
			User.find( id )
		end

		def initial_account
			user = User .create()
			Music.find( :all ) .each do | music |
				Score.create( :user_id => user[ :id ] , :music_id => music[ :id ] ) #=> now music id is i
			end

			user
		end

		def set_tag( user_id , tag_name )
			tag = Tag.find_by_name( tag_name )
			return if tag .nil?
			return unless TagOfUser.where( :user_id => user_id , :tag_id => tag[ :id ] ) .nil?
			TagOfUser.create( :user_id => user_id , :tag_id => tag[ :id ] ) 
		end
	end
end
