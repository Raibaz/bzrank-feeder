require "rubygems"

$:.unshift File.dirname(__FILE__) + "/lib"

require "mongoclient"
require "event"
require "gamestart"

basePath  = (ARGV.shift || ENV['TMPDIR'])
mongoHost = (ARGV.shift || 'localhost')
mongoPort = (ARGV.shift || 27080)

specialEventMappings = {
  "worldtype" => "GameStart"
}

Dir.glob("#{basePath}*.bzrankdata") do |rb_file|
  file = File.new(rb_file, "r")

  tmp = rb_file[rb_file.rindex("/"), rb_file.length]
  gameStartTimestamp = tmp[1,tmp.index(".")-1]
  puts gameStartTimestamp  

  mongo = MongoClient.new(mongoHost, mongoPort)    
  countBefore = mongo.countEvents
  puts "Before import: #{countBefore} events total."  

  while (line = file.gets)
    
    data = line.chop.split("\t")    

    event = Event.new(mongo, data, gameStartTimestamp)        

    if(specialEventMappings.include? event.type) 
      then event = Kernel.const_get(specialEventMappings[event.type]).new(mongo, data, gameStartTimestamp);
    end

    event.store
        
  end
  file.close
  countAfter = mongo.countEvents
  puts "After import: #{countAfter} events total."

  if((countAfter - countBefore) < 5) then
    mongo.deleteGame(gameStartTimestamp)
  end

  File.rename(rb_file, rb_file.gsub(/bzrankdata$/, 'processed-bzrankdata'))
end
