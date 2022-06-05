class Customer
  attr_reader :id, :first_name, :last_name, :created_at

  def initialize(customer)
    @id = customer[:id]
    @first_name = customer[:first_name]
    @last_name = customer[:last_name]
    @created_at = customer[:created_at]

  end
end
