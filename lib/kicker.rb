# require "kicker/version"

# require 'active_support/core_ext'
require 'rdoc'
require 'rdoc/generator'
require 'rdoc/options'
require 'rdoc/parser/ruby'
require 'rdoc/stats'
require 'rspec/mocks'
require 'pry'

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'kicker/param'
require 'kicker/method'
require 'kicker/node'

module Kicker
  class Generator
    attr_reader :output

    NL = "\n".freeze
    INDENT = '  '.freeze

    def initialize file_path
      top_level = RDoc::TopLevel.new(file_path)
      if RUBY_VERSION.to_f < 2.0
        RDoc::TopLevel.reset
      end

      if defined?(RDoc::Store)
        store = RDoc::Store.new
        top_level.store = store
        stats = RDoc::Stats.new(store, 1)
      else
        stats = RDoc::Stats.new(1)
      end

      parser = RDoc::Parser::Ruby.new(
        top_level,
        file_path,
        File.read(file_path),
        RDoc::Options.new,
        stats,
        )

      scan    = parser.scan

      scope   = Node.new(scan)

      @indent = 0
      @output = "require 'spec_helper'" << NL * 2

      scope.subnodes.each do |obj|
        generate(obj)
      end
    end

    def result
      @output
    end

    private

    def expect value, expectation, subject
      o "expect{ #{subject}.#{value} }.#{expectation % subject}"
    end

    def subject value
      o "subject{ #{value} }" << NL
    end

    def context value
      o "context '#{value}'" do
        yield
      end
    end

    def describe node
      node = @indent == 0 ? node : "'#{node}'"
      o "describe #{node}" do
        yield
      end
    end

    def it desc
      o "it '#{desc}'" do
        yield
      end
    end

    def o value = nil
      if value.nil?
        @separate_next_line = false
        return @output << NL
      end

      if block_given?
        nl if @separate_next_line
        o "#{value} do"
        @indent += 1
        yield
        @indent -= 1
        o "end"
        @separate_next_line = true
      else
        @output += (INDENT * @indent) << value << NL
      end
    end
    alias_method :nl, :o

    def generate node
      describe node do
        subject node.module? ? "Class.new.extend(#{node.name})" : "described_class.new#{node.initialize_method.required_param_list}"

        if node.instance_methods.any?
          if node.repeating_instance_params.any?
            node.repeating_instance_params.each do |param_name|
              o "let(:#{param_name}){ double }"
            end
            nl
          end

          node.all_methods.each do |method|
            describe method do
              method.expectations.each do |(description, expectation)|
                it description do
                  method.required_params.each do |param|
                    o "#{param.name} = double"
                  end
                  expect "#{method.name << method.required_param_list}", expectation, method.subject
                end
              end

              if method.optional_params.any?
                method.expectations.each do |(description, expectation)|
                  it description do
                    method.required_params.each do |param|
                      o "#{param.name} = double"
                    end
                    method.optional_params.each do |param|
                      o "#{param.name} = #{param.default}"
                    end
                    expect "#{method.name << method.param_list}", expectation, method.subject
                  end
                end
              end
            end
          end
        end

        node.subnodes.each do |subnode|
          generate(subnode)
        end
      end
    end
  end
end

puts Kicker::Generator.new(
  File.expand_path('../../spec/source/class_methods.rb', __FILE__)
  ).output
