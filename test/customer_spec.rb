require './lib/entry.rb'
require_relative 'spec_helper'

RSpec.describe Customer do
  before :each do
    @c  = Customer.new({
                      :id => 6,
                      :first_name => "Joan",
                      :last_name => "Clarke",
                      :created_at => Time.now,
                      :updated_at => Time.now
                      })
  end

  it 'exists' do
    expect(@c).to be_a(Customer)
  end

  it 'returns the interger id' do
    expect(@c.id).to eq(6)
  end

  it 'has a first name' do
    expect(@c.first_name).to eq("Joan")
  end

  it 'has a last name' do
    expect(@c.last_name).to eq("Clarke")
  end

  it 'has a created at time' do
    expect(@c.created_at). to be_a(Time)
  end

  it ' has updated at time' do
    expect(@c.updated_at).to be_a(Time)
  end


end
