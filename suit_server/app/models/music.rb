class Music < ActiveRecord::Base
	attr_accessible :artist, :name, :played_times

	class << self
		def fetch( music_id )
			Music.find( music_id )
		end

		def best_select( user_id )
			best_list = Score.get_score_list( user_id )
			hist_list = History.get_history_list( user_id )

			best_list .each do | b |
				return Music.fetch( b[ :music_id ] ) if hist_list .select { |x| x[ :music_id ] == b[ :music_id ] } .empty?
			end
			hist_list[ hist_list .length - 1 ] 
		end

		def feedback( user_id , music_id , score )
			s = Score.where( :user_id => user_id , :music_id => music_id ) [ 0 ]
			s[ :score ] = s[ :score ] * 0.3 + score * 0.7
			s .save
		end
	end
end
