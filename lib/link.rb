class Link
	include DataMapper::Resource

	has n, :tags, :through => Resource

	property :id, Serial #will be auto incremented for every second
	property :title, String
	property :url, String
	# property :tags, String

end