class GameStart < Event
  def store
    @mongo.storeGameStart(self)
  end

  def to_json
  	{"start" => @timestamp, "type" => @player}.to_json
  end
end