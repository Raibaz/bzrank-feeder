class Shotfired < Event

  def processData
    player_id = getPlyerId(@data[0])
    bullet = (@data.size == 2) ? @data[1] : 'BULLET'

    @redis.zincrby("shots:#{player_id}", 1, bullet)
    @players_to_recalculate << player_id
  end


end