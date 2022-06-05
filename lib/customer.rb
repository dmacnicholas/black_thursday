class Customer
  attr_reader :id

  def initialize(customer)
    @id = customer[:id]

  end
end
