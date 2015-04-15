module Kicker
  class Node
    def initialize node
      @node = node
    end

    def initialize_method
      class_methods.find(&:initialize?)
    end

    def repeating_instance_params
      @repeating_instance_params ||= instance_methods
        .flat_map(&:params)
        .group_by(&:name)
        .select{ |_, v| v.count > 1 }
        .keys
    end

    def all_methods
      instance_methods + class_methods
    end

    def instance_methods
      @instance_methods ||= methods['instance'][:public].map{ |m| Method.new(m) }
    end

    def class_methods
      @class_methods ||= methods['class'][:public].map{ |m| Method.new(m) }
    end

    def subnodes
      (@node.classes + @node.modules).map{ |n| self.class.new(n) }
    end

    def module?
      @node.module?
    end

    def name
      @node.name
    end
    alias_method :to_s, :name

    private

    def methods
      @methods ||= @node.methods_by_type
    end
  end
end
