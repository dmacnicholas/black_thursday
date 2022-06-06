require_relative './spec_helper'

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




end
