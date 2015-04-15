class ClassMethods
  attr_reader :param

  def initialize required, optional = nil, *args, &block
    # no-op
  end

  def run
    true
  end

  def valid?
    true
  end

  def valid_required? required
    true
  end

  def param= required
    @param = required
  end

  def 

  def save!
    raise StandardError.new
  end

  # class << self
    cattr_reader :param

    def self.create required, optional = nil, *args, &block
      self.new(required, optional, *args, &block)
    end

    def self.class_param= value
      @class_param = value
    end

  #   private

  #   def private_eigenclass_method
  #     true
  #   end
  # end

  private

  def private_class_method required, optional = nil, *args, &block
    true
  end
end
