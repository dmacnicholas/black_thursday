class Customer
  attr_reader :id, :first_name

  def initialize(customer)
    @id = customer[:id]
    @first_name = customer[:first_name]

  end
end
