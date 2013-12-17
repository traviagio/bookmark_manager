class Tag

	include DataMapper::Resource

	has n, :links, :through => Resource

	property :id, Serial   #Serial means that it will be nubers
	property :text, String  #it will be stored as a string (character var in the database software)

end