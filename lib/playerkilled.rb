class Playerkilled < Event

  def processData
    player_id = getPlyerId(@data[0])
    killed_by = getPlyerId(@data[1])
    bullet = (@data.size == 3) ? @data[2] : 'BULLET'

    @redis.zincrby("killed_by_player:#{player_id}", 1, killed_by)
    @redis.zincrby("killed_by_weapon:#{player_id}", 1, bullet)

    @redis.zincrby("kill_player:#{killed_by}", 1, player_id)
    @redis.zincrby("kill_with_weapon:#{killed_by}", 1, bullet)

    @redis.incr("killed:#{player_id}")
    @redis.incr("kill:#{killed_by}")

    @players_to_recalculate << player_id
    @players_to_recalculate << killed_by
  end

end