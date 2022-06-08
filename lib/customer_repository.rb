require_relative './enumerable'
require_relative 'entry'

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
                        :created_at => Time.parse(row[:created_at]),
                        :updated_at => Time.parse(row[:updated_at])
                        })
    end
  end

  def inspect
    "#<#{self.class} #{@all.size} rows>"
  end

  def find_all_by_first_name(name)
    match = []
    @all.find_all do |row|
      if row.first_name.upcase.include?(name.upcase) == true
        match << row
      end
    end
  end

  def find_all_by_last_name(name)
    match = []
    @all.find_all do |row|
      if row.last_name.upcase.include?(name.upcase) == true
        match << row
      end
    end
  end

  def add_new(new_id, attributes)
    @all << Customer.new({
                          id: new_id,
                          first_name: attributes[:first_name],
                          last_name: attributes[:last_name],
                          created_at: attributes[:created_at],
                          updated_at: attributes[:updated_at]
                        })

  end

  def change(id, key, value)
    if key == :last_name
      find_by_id(id).last_name = value
    else key == :first_name
      find_by_id(id).first_name = value
    end
    find_by_id(id).updated_at = Time.now
  end


end
