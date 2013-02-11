require 'rubygems'

require 'rss'
require 'open-uri'

require 'models.rb'


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

