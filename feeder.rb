require "rubygems"

$:.unshift File.dirname(__FILE__) + "/lib"

require "event"
require "gamestart"
require "mongoclient"

basePath = (ARGV.shift || ENV['TMPDIR'])

specialEventMappings = {
  "worldtype" => "GameStart"
}

Dir.glob("#{basePath}*.bzrankdata") do |rb_file|
  file = File.new(rb_file, "r")

  tmp = rb_file[rb_file.rindex("/"), rb_file.length]
  gameStartTimestamp = tmp[1,tmp.index(".")-1]
  puts gameStartTimestamp  

  mongo = MongoClient.new("localhost", 27080)    
  count = mongo.countEvents
  puts "Before import: #{count} events total."  

  while (line = file.gets)
    
    data = line.chop.split("\t")    

    event = Event.new(mongo, data, gameStartTimestamp)        

    if(specialEventMappings.include? event.type) 
      then event = Kernel.const_get(specialEventMappings[event.type]).new(mongo, data, gameStartTimestamp);
    end

    event.store
        
  end
  file.close
  count = mongo.countEvents
  puts "After import: #{count} events total."

  #File.rename(rb_file, rb_file.gsub(/bzrankdata$/, 'processed-bzrankdata'))
end