require_relative 'crudable'
require_relative 'entry'

class TransactionRepository
  include Crudable
  attr_reader :all

  def initialize(file_path)
    @all = []

    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      @all << Transaction.new({
        id: row[:id],
        invoice_id: row[:invoice_id],
        credit_card_number: row[:credit_card_number],
        credit_card_expiration_date:  row[:credit_card_expiration_date],
        result: row[:result].downcase,
        created_at: Time.parse(row[:created_at]),
        updated_at: Time.parse(row[:updated_at])
        })
    end
  end

  def inspect
    "#<#{self.class} #{@all.size} rows>"
  end

  def find_all_by_invoice_id(id)
    @all.find_all {|row| row.invoice_id == id}
  end

  def find_all_by_credit_card_number(cc_number)
    @all.find_all do |row|
      row.credit_card_number == cc_number
    end
  end

  def find_all_by_result(rslt)
    @all.find_all {|row| row.result == rslt}
  end

  def add_new(new_id, attributes)
    t = Transaction.new({
      id: new_id,
      invoice_id: attributes[:invoice_id],
      credit_card_number: attributes[:credit_card_number],
      credit_card_expiration_date: attributes[:credit_card_expiration_date],
      result: attributes[:result],
      created_at: attributes[:created_at],
      updated_at: attributes[:updated_at]
    })
    @all.append(t)
    t
  end

  def change(id, key, value)
    if key == :credit_card_number then find_by_id(id).credit_card_number = value
    elsif key == :credit_card_expiration_date then find_by_id(id).credit_card_expiration_date = value
    elsif key == :result then find_by_id(id).result = value
    else return nil
    end
    find_by_id(id).updated_at = Time.now
  end
end
