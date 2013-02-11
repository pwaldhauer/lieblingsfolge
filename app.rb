require 'rubygems'

require 'sinatra'

require 'sinatra-twitter-oauth'

require 'rss'
require 'open-uri'

require './models.rb'

set :twitter_oauth_config,  :key => 'KEY',
                            :secret   => 'SECRET',
                            :callback => 'http://lieblingsfolge.herokuapp.com/auth'

enable :sessions

get '/' do

  @folgen = Folge.all();

  @folgen.sort! do |a, b|
      b.votes.count <=> a.votes.count
  end

    erb :index

end

get '/vote' do
	login_required

    @old_vote = Vote.all(:twitter_id => user.screen_name)
    @old_vote.destroy!

    Vote.create(
        :twitter_id => user.screen_name,
        :folge_id => params[:id]
    )

    redirect '/'
end

get '/update' do

  @regexp = /28_(\d+): (.*)/

  url = 'http://konferenz28.de/rss'
  open(url) do |rss|
    feed = RSS::Parser.parse(rss)
    feed.items.each do |item|

      @split = @regexp.match(item.title);
    
      puts @split[1] + " - " + @split[2]

      @folge = Folge.first(:nummer => @split[1].to_i)

      puts @folge
      if @folge != nil then
          next
      end

      @folge = Folge.new
      @folge.link = item.link
      @folge.nummer = @split[1].to_i
      @folge.title = @split[2]
      @folge.save

    end
  end

  redirect '/'
end

