$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'kicker'
require 'rspec'
require 'rspec/autorun'

RSpec.configure do |config|

end

# Dir[File.expand_path('../source/*.rb', __FILE__)].each do |f|
# end

Dir[File.expand_path('../source/*.rb', __FILE__)].each do |source|
  require_relative source
  result = File.read(source.gsub('source', 'result').gsub('.rb', '_spec.rb'))
  describe "#{source}" do
    it 'works' do
      expect(Kicker::Generator.new(source).result).to eq(result)
    end
  end
end
