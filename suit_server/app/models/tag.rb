class Tag < ActiveRecord::Base
 	attr_accessible :name

 	class << self
 		def random_fetch
 			fetch_num = 6
 			Tag.find( :all , :order => "random()" , :limit => 6 )
 		end

 		def fetch_music( id )
 			TagOfMusic.where( :tag_id => id ) .find( :first , :order => "random()" )
 		end
 	end
end
