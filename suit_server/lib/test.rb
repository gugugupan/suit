=begin    Migrate Music 
music = []
artist = [] 

File.open( "lib/tracks.txt" , "r" ) do |file|
	while line = file .gets
		music << line
	end
end

File.open( "lib/artists.txt" , "r" ) do |file|
	while line = file .gets
		artist << line
	end
end

music .length .times do |i|
	Music.create( :name => music[ i ] , :artist => artist[ i ] , :played_times => 0 )
end
=end

=begin    Migrate Tags
i = 1 
File.open( "lib/tag_list.txt" ) do | file |
	while line = file .gets
		line = line .delete( "\n" ) ;
		tag = Tag .new( :name => line )
		tag[ :id ] = i
		tag .save
		i += 1 
	end
end
=end

=begin
i = 0 
File.open( "lib/tagofmusic.txt" ) do | file |
	while line = file .gets
		i += 1
		unless Music .find_by_id( i ) .nil?
			line .split( ";" ) .each do | tag_str |
				tag = Tag .find_by_name( tag_str )
				TagOfMusic.create( :music_id => i , :tag_id => tag[ :id ] ) unless tag .nil?
			end
		end
	end
end
=end

=begin     Delete Tags
tag_list = Tag.find( :all )
tag_list .each do | tag | 
	tag[ :count ] = TagOfMusic.where( :tag_id => tag[ :id ] ) .length
	#puts tag[ :count ]
end
tag_list = tag_list .sort { | a , b | a[ :count ] <=> b[ :count ] } #.reverse
#File.open("lib/data.yaml", "wb") {|f| YAML.dump(tag_list[ 0 , 100 ], f) }
( Tag.count - 100 ) .times do | i |
	TagOfMusic.where( :tag_id => tag_list[ i ] [ :id ] ) .delete_all
	Tag.delete( tag_list[ i ] [ :id ] )
end 
=end

=begin    Delete Music
File.open( "lib/music2delete.txt" ) do | file |
	while line = file .gets
		id = line .to_i
		History .where( :music_id => id ) .delete_all
		Score .where( :music_id => id ) .delete_all
		Music .delete( id )
	end
end
=end