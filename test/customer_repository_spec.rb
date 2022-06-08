require './lib/entry.rb'

RSpec.describe CustomerRepository do
  before :each do
    @customer_repository = CustomerRepository.new("./data/customers.csv")
  end

  it 'exists' do
    expect(@customer_repository).to be_a(CustomerRepository)
  end

  it 'returns an array of all know customer instances' do
    expect(@customer_repository.all.count).to eq(1000)
  end

  it 'returns either nil or an instance of Customer with a matching ID' do
    expect(@customer_repository.find_by_id(100)).to be_a(Customer)
    expect(@customer_repository.find_by_id(3000)).to eq(nil)
  end

  it 'returns either [] or one or more matches which have a first name matching ' do
    fragment = "oe"
    expected = @customer_repository.find_all_by_first_name(fragment)
    expect(@customer_repository.find_all_by_first_name("oe").count).to eq(8)
    expect(@customer_repository.find_all_by_first_name("hh")).to eq([])
  end

  it 'returns either [] or one or more matches which have a last name matching ' do
    fragment = "On"
    expected = @customer_repository.find_all_by_last_name(fragment)
    expect(@customer_repository.find_all_by_last_name("On").count).to eq(85)
    expect(@customer_repository.find_all_by_last_name("HH")).to eq([])
  end

  it 'creates a new Customer instance with the provided attributes ' do
    attributes = {
        :first_name => "Joan",
        :last_name => "Clarke",
        :created_at => Time.now,
        :updated_at => Time.now
      }
      @customer_repository.create(attributes)
      expect(@customer_repository.all[-1].first_name).to eq("Joan")
      expect(@customer_repository.all[-1].id).to eq(1001)
  end

  it 'can update attributes with a corresponding id' do
    attributes = {
        :first_name => "Joan",
        :last_name => "Clarke",
        :created_at => Time.now,
        :updated_at => Time.now
      }
      @customer_repository.create(attributes)
      customer_updated_at = @customer_repository.find_by_id(1001).updated_at
      expect(@customer_repository.find_by_id(1001)).to be_a(Customer)
      @customer_repository.update(1001,last_name: "Smith")
      @customer_repository.update(1001,first_name: "Billy")

      expect(@customer_repository.find_by_id(1001).last_name).to eq("Smith")
      expect(@customer_repository.find_by_id(1001).first_name).to eq("Billy")

      expect(@customer_repository.find_by_id(1001).updated_at).to be > customer_updated_at
    end

    it 'delete the Transaction instance with the corresponding id' do
      attributes = {
          :first_name => "Joan",
          :last_name => "Clarke",
          :created_at => Time.now,
          :updated_at => Time.now
        }
      @customer_repository.create(attributes)
      expect(@customer_repository.find_by_id(1001)).to be_a Customer
      @customer_repository.delete(1001)
      expect(@customer_repository.find_by_id(1001)).to eq(nil)
    end
end
