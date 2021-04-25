class Command 
  def initialize(data)
    @data = data
  end

  attr_reader :data

  def self.send(data)
    # self is a name of the instance class -> Command
    # but because every command type class inherits from Command class
    # self will differ; for example: for IssueTransaction class 
    # self is equal to Transactions::IssueTransaction
    ##if !group_opr 
    #  validate_against = self::SCHEMA.except!(:group_transaction, :group_uid)
    #  ClassyHash.validate(data, validate_against)
    #else
    #  binding.pry
    #  ClassyHash.validate(data, self::SCHEMA)
    #end
    ClassyHash.validate(data, self::SCHEMA)
    new(data)
  end
end