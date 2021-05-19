class Command 
  def initialize(data)
    @data = data
  end

  attr_reader :data

  def self.send(data)
    ClassyHash.validate(data, self::SCHEMA)
    new(data)
  end
end