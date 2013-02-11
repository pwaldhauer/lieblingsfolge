require 'rubygems'

require 'sinatra'

require 'sinatra-twitter-oauth'

require './models.rb'

set :twitter_oauth_config,  :key => 'KEY',
                            :secret   => 'SECRET',
                            :callback => 'http://bloody.debian:9393/auth'

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