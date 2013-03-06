class History < ActiveRecord::Base
 	attr_accessible :music_id, :user_id

 	class << self
 		def get_history_list( user_id ) 
 			History.where( { :user_id => user_id } ) .order( "created_at DESC" ) .find( :all , :limit => 20 )
 		end

 		def add_history( user_id , music_id )
 			History.create( :user_id => user_id , :music_id => music_id )
 		end
 	end
end
