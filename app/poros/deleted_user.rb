class DeletedUser
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def username
    'User Deleted'
  end

  def eql?(other)
    other.instance_of?(DeletedUser) && self.id == other.id
  end

  def hash
    id
  end
end
