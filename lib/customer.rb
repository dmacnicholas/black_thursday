class Customer
  attr_reader :id, :first_name, :last_name

  def initialize(customer)
    @id = customer[:id]
    @first_name = customer[:first_name]
    @last_name = customer[:last_name]

  end
end
