module ModuleMethods
  def test_module_method value, params = {}, test: 1, &block
    1
  end

  def self.test_eigen_method value, params = {}, &block
    3
  end

  private

  def test_priavte_module_method value, params = {}, &block
    2
  end
end
