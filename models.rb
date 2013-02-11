require 'rubygems'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://lieblingsfolge:test@localhost/lieblingsfolge")

class Folge
	include DataMapper::Resource

	property :id, Serial
	property :nummer, Integer
	property :title, String, :length => 250
	property :link, String

	has n, :votes
end

class Vote
	include DataMapper::Resource

	property :id, Serial
	property :twitter_id, String
	property :folge_id, Integer

	belongs_to :folge
end


DataMapper.finalize.auto_upgrade!