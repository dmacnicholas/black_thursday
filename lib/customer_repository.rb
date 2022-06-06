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

  def find_all_by_first_name(name)
    match = []
    @all.find_all do |row|
      if row.first_name.upcase.include?(name.upcase) == true
        match << row
      end
    end
  end

end
