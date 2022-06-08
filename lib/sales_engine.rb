require_relative 'entry'

class SalesEngine
  attr_reader :items, :merchants, :analyst, :invoices, :invoice_items, :transactions, :customers

  def initialize(items_path, merchants_path, invoice_path, invoice_items_path, transactions_path, customers_path)

    @items = ItemRepository.new(items_path)
    @merchants = MerchantRepository.new(merchants_path)
    @invoices = InvoiceRepository.new(invoice_path)
    @invoice_items = InvoiceItemRepository.new(invoice_items_path)
    @transactions = TransactionRepository.new(transactions_path)
    @customers = CustomerRepository.new(customers_path)
    @analyst = SalesAnalyst.new(@items, @merchants, @invoices, @transactions, @invoice_items, @customers)
  end

  def self.from_csv(data)
    SalesEngine.new(data[:items], data[:merchants], data[:invoices], data[:invoice_items], data[:transactions], data[:customers])
  end
end
