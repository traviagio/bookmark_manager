class Link
	include DataMapper::Resource

	property :id, Serial #will be auto incremented for every second
	property :title, String
	property :url, String

end