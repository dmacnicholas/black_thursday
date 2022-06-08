require './lib/entry.rb'
require_relative 'spec_helper'

RSpec.describe Merchant do
  it 'exists' do
    merchant = Merchant.new({:id => 5, :name => "Turing School"})

    expect(merchant).to be_a(Merchant)
  end

  it 'contains information' do
    merchant = Merchant.new({:id => 5, :name => "Turing School"})

    expect(merchant.id).to be(5)
    expect(merchant.name).to eq("Turing School")
  end
end
