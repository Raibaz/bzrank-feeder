class Flaggrabbed < Event

  def processData
    player_id = getPlyerId(@data[0])
    bullet = @data[1]

    @redis.zincrby("flaggrabs:#{player_id}", 1, bullet)
    @players_to_recalculate << player_id
  end
  
end