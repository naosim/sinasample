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

  def to_s
    @value.to_s
  end

  def to_i
    @value.to_i
  end
end

module Entity
  include IsExist
  attr_reader :id
end

# JapaneseMixin
class Array
  def 個別要素を変換
    self.map {|item|
      yield item
    }
  end
  def 個別要素を処理
    self.each {|item|
      yield item
    }
  end
end

class Object
  def から
    self
  end
  def し
    self
  end
  def して
    self
  end
  def する
    self
  end
  def で(clazz = nil)
    self.を(clazz)
  end

  def に
    self
  end

  def を(clazz = nil)
    if clazz == nil then
      return self
    end
    clazz.new(self)
  end
end
class Foo
  def initialize(str)
    @str = str
  end
  def 表示
    p @str
  end
end
