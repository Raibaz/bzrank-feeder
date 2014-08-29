require "event"
require "net/http"
require "json"

class MongoClient

	attr_accessor :basePath	
	
	def initialize(baseUrl, port)
		@baseUrl = baseUrl
		@port = port
		@basePath = "bzrank"	
		@eventsCollection = "#{@basePath}/events"
		@gamesCollection = "#{@basePath}/games"

		post("_connect", 'server' => 'localhost:27017')
	end

	def hello
		resp = get('_hello')
		puts resp		
	end

	def storeEvent(event)
		eventToStore = {"docs" => event.to_json}		
		resp = post("#{@eventsCollection}/_insert", eventToStore)	
	end

	def listEvents
		get("#{@eventsCollection}/_find")
	end

	def countEvents		
		resp = post("#{@eventsCollection}/_cmd", {"cmd" => {"count" => "events"}.to_json})
		resp = JSON.parse(resp.body)
		resp['n']
	end

	def storeGameStart(event)
		eventToStore = {"docs" => event.to_json}
		resp = post("#{@gamesCollection}/_insert", eventToStore)
	end

	def deleteGame(gameStartTimestamp)
		resp = post("#{@eventsCollection}/_remove", {"start" => gameStartTimestamp})		
		resp = post("#{@gamesCollection}/_remove", {"@game" => gameStartTimestamp})		
	end

	def get(url)
		uri = URI("http://#{@baseUrl}:#{@port}/#{url}")
		resp = Net::HTTP.get(uri)
		resp = JSON.parse(resp)
		resp
	end

	def post(url, data)
		uri = URI("http://#{@baseUrl}:#{@port}/#{url}")				
		resp = Net::HTTP.post_form(uri, data)
		resp		
	end

	private :get, :post	
end