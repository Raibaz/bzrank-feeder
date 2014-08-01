class Event
  
  attr_accessor :data  
  attr_accessor :timestamp
  attr_accessor :player
  attr_accessor :type
  attr_accessor :target
  attr_accessor :argument

  def initialize(mongo, data, game)
    @data = data    
    @mongo = mongo

    @timestamp = data[0]
    @type      = data[1]
    @player    = data[2]
    @target    = data[3]
    @argument  = data[4]
    @game      = game

  end

  def store
    @mongo.storeEvent(self)
  end

  def to_s
    "#@timestamp @type @player @target @argument"
  end

  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hash[var] = self.instance_variable_get var
    end
    hash.to_json
  end  
end