require_relative './enumerable'

class CustomerRepository
  include Enumerable
  attr_reader :file_path, :all

  def initialize(file_path)
    @file_path = file_path
    @all = []

    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      @all << Customer.new({
                        :id => row[:id],
                        :first_name => row[:first_name],
                        :last_name => row[:last_name],
                        :created_at => Time.now,
                        :updated_at => Time.now
                        })
    end
  end

end
