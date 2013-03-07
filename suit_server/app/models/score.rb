class Score < ActiveRecord::Base
	attr_accessible :music_id, :score, :user_id

	class << self
		def get_score_list( user_id )
 			Score.where( { :user_id => user_id } ) .order( "score DESC" ) .find( :all , :limit => 25 )
 		end
 	end
end
