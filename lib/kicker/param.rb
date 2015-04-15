module Kicker
  class Param
    def initialize param_def
      @param_def = param_def
    end

    def default
      case @param_def
      when /=\W*(.+)/
        $1
      when /^\*/
        '{}'
      when /^\&/
        '->{ }'
      else
        'nil'
      end
    end

    def name
      @param_def[/[\w]+/]
    end
    alias_method :to_s, :name

    def required?
      !(@param_def =~ /^\*|^\&|=/)
    end
  end
end
