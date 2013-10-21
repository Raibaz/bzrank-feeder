require 'digest/md5'

class Event

  attr_accessor :redis
  attr_accessor :data
  attr_accessor :players_to_recalculate

  def initialize(redis, data)
    @redis = redis
    @data = data
    @players_to_recalculate = Array.new

    processData
  end

  def getPlyerId(player_name)
    playerDigest = Digest::MD5.hexdigest(player_name)
    playerId = @redis.get("user:#{playerDigest}:id")

    if !playerId
      playerId = @redis.incr("next:user:id")
      @redis.set("user:#{playerDigest}:id", playerId)
    end

    playerId.to_i
  end
end