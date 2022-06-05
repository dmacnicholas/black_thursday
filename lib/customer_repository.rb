class CustomerRepository
  attr_reader :file_path, :all

  def initialize(file_path)
    @file_path = file_path
    @all = []

    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      @all << Customer.new({
                        :id => 6,
                        :first_name => "Joan",
                        :last_name => "Clarke",
                        :created_at => Time.now,
                        :updated_at => Time.now
                        })
    end
  end

end
