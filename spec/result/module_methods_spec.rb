require 'spec_helper'

describe ModuleMethods do
  subject{ Class.new.extend(ModuleMethods) }

  describe '#test_module_method' do
    it 'does not raise an error' do
      value = double
      params = double
      expect{ subject.test_module_method(value, params) }.not_to raise_error
    end
  end

  describe '::test_eigen_method' do
    it 'does not raise an error' do
      value = double
      params = double
      expect{ described_class.test_eigen_method(value, params) }.not_to raise_error
    end
  end
end
