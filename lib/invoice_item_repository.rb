require_relative 'crudable' 
require_relative 'entry'

class InvoiceItemRepository
  include Crudable
  attr_reader :all

  def initialize(file_path)
    @file_path = file_path
    @all = []

    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      @all << InvoiceItem.new({
        id: row[:id],
        item_id: row[:item_id],
        invoice_id: row[:invoice_id],
        quantity: row[:quantity],
        unit_price: BigDecimal(row[:unit_price].to_i * 0.01, 10),
        created_at: Time.parse(row[:created_at]),
        updated_at: Time.parse(row[:updated_at])
      })
    end
  end

  def inspect
    "#<#{self.class} #{@all.size} rows>"
  end

  def find_all_by_invoice_id(inv_id)
    @all.find_all {|row| row.invoice_id == inv_id}
  end

  def add_new(new_id, attributes)
    ii = InvoiceItem.new({
      id: new_id,
      :item_id => attributes[:item_id],
      :invoice_id => attributes[:invoice_id],
      :quantity => attributes[:quantity],
      :unit_price => attributes[:unit_price],
      :created_at => Time.parse(attributes[:created_at].to_s),
      :updated_at => Time.parse(attributes[:updated_at].to_s)
      })
    @all.append(ii)
    ii
  end

  def find_all_by_item_id(item_id)
    test = @all.find_all { |invoice_item| invoice_item.item_id == item_id }
  end

  def change(id, key, value)
    if key == :quantity then find_by_id(id).quantity = value
    elsif key == :unit_price then find_by_id(id).unit_price = value
    else
      return nil
    end
    find_by_id(id).updated_at = Time.now
  end
end
