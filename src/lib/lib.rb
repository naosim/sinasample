module IsExist
  def isExist
    true
  end

  def isNotExist
    !isExist
  end
end

class ValueObject
  attr_reader :value
  def initialize(value)
    @value = value
  end
end

module Entity
  include IsExist
  attr_reader :id
end
