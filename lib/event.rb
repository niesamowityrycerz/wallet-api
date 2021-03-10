class Event < RailsEventStore::Event
  def self.strict(data)
    ClassyHash.validate(data, self::SCHEMA)
    self.new({data: data})
  end
end