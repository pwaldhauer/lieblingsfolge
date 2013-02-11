require 'rubygems'

require 'sinatra'

require 'sinatra-twitter-oauth'

require 'rss'
require 'open-uri'

require './models.rb'

set :twitter_oauth_config,  :key => ENV['TWITTER_KEY'],
                            :secret   => ENV['TWITTER_SECRET'],
                            :callback => ENV['TWITTER_CALLBACK'],
                            :login_template => {:erb => :login}

enable :sessions

get '/' do

  if session[:user] then
    @logged_in = true
  else 
    @logged_in = false
  end

  @folgen = Folge.all(:order => :nummer.desc);

  @folgen.sort! do |a, b|
    if b.votes.count == a.votes.count then
      b.nummer <=> a.nummer
    else
      b.votes.count <=> a.votes.count
    end
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

