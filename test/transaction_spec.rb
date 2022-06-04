require_relative './spec_helper'

RSpec.describe Transaction do
  before :each do
  @t = Transaction.new({
    :id => 6,
    :invoice_id => 8,
    :credit_card_number => "4242424242424242",
    :credit_card_expiration_date => "0220",
    :result => "success",
    :created_at => Time.now,
    :updated_at => Time.now
  })
  end

  it 'is an instance of Transaction' do
    expect(@t).to be_instance_of(Transaction)
  end

  it 'has an id' do
    expect(@t.id).to eq(6)
  end

  it 'has an invoice id' do
    expect(@t.invoice_id).to eq(8)
  end
end
