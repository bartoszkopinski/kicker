require 'spec_helper'

describe ClassMethods do
  subject{ described_class.new(double, double, double) }

  describe '#test_class_method' do
    it 'does not raise an error' do
      required = double
      optional = double
      expect{ subject.test_class_method(required, optional) }.not_to raise_error
    end
  end

  describe '::test_eigen_method' do
    it 'does not raise an error' do
      required = double
      optional = double
      expect{ described_class.test_eigen_method(required, optional) }.not_to raise_error
    end
  end
end
