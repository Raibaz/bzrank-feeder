require "rubygems"
require "redis"

$:.unshift File.dirname(__FILE__) + "/lib"

require "event"
require "shotfired"
require "flaggrabbed"
require "playerkilled"
require "flagdropped"

basePath = (ENV['TMPDIR'] || ARGF.read) + "/"

redis = Redis.new
players_to_recalculate = Array.new

Dir.glob("#{basePath}*.bzrankdata") do |rb_file|
  file = File.new(rb_file, "r")
  while (line = file.gets)
    
    data = line.chop.split("\t")
    event, *data = data
    
    begin
      event = Kernel.const_get(event.capitalize).new(redis, data)
      players_to_recalculate = (event.players_to_recalculate + players_to_recalculate).uniq
    rescue
      puts "Cannot handle #{event} data type... Aborting..."
      exit 2
    end

  end
  file.close

  File.rename(rb_file, rb_file.gsub(/bzrankdata$/, 'processed-bzrankdata'))
end