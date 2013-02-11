require 'rubygems'

require 'sinatra'

require 'sinatra-twitter-oauth'

require 'models.rb'

set :twitter_oauth_config,  :key => 'KEY',
                            :secret   => 'SECRET',
                            :callback => 'http://bloody.debian:9393/auth'

enable :sessions

get '/' do

  #  @folge1 = Folge.new(
  #      :nummer =>  1,
  #      :title => 'asdas adsd asdasd',
  #      :link => 'asdasda'
  #  );
  #  @folge1.save
  
  @folgen = Folge.all();

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