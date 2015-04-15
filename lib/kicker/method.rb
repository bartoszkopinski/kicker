module Kicker
  class Method
    def initialize any_method
      @any_method   = any_method
    end

    def subject
      class_method? ? 'described_class' : 'subject'
    end

    def class_method?
      @any_method.type == 'class'
    end

    def initialize?
      name == 'new'
    end

    def required_params
      params_by_requirement[true] || []
    end

    def optional_params
      params_by_requirement[false] || []
    end

    def pretty_name
      @any_method.pretty_name
    end
    alias_method :to_s, :pretty_name

    def name
      @any_method.name
    end

    def required_param_list
      required_params.join(', ').tap do |list|
        list.prepend('(') << ')' unless list.empty?
      end
    end

    def param_list
      params.join(', ').tap do |list|
        list.prepend('(') << ')' unless list.empty?
      end
    end

    # SURROUND_WITH_PARENS = lambda do |list| 
    #   list.tap do |list|
    #     list.prepend('(') << ')' unless list.empty?
    #   end 
    # end

    def expectations
      case name
      when /\?$/
        [
          ['returns true', 'to be_truthy'],
          ['returns false', 'to be_falsy'],
        ]
      when /\!$/
        [
          ['does not raise an error', 'not_to raise_error'],
          ['raises an error', 'to raise_error'],
        ]
      when /\=$/
        [
          ['assigns a value', "to change{ %s.#{name[0..-2]} }"],
        ]
      else
        [
          ['does not raise an error', 'not_to raise_error'],
        ]
      end
    end

    def params
      @params ||= @any_method.params[1..-2].split(',').map do |pd| 
        Param.new(pd.strip)
      end
    end

    private

    def params_by_requirement
      @params_by_requirement ||= params.group_by(&:required?)
    end

  end
end
