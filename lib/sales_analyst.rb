require_relative './enumerable'

class SalesAnalyst
  include Enumerable
  attr_reader :item_repository, :merchant_repository, :invoice_repository,
  :transaction_repository, :invoice_item_repository

  def initialize(item_repo, merchant_repo, invoice_repo, transaction_repo, invoice_item_repo)
    @item_repository = item_repo
    @merchant_repository = merchant_repo
    @invoice_repository = invoice_repo
    @transaction_repository = transaction_repo
    @invoice_item_repository = invoice_item_repo
  end

  def average_items_per_merchant
    (@item_repository.all.length.to_f / @merchant_repository.all.length).round(2)
    #round(2) rounds it to the second decimal place (2.88 vs 2.8842)
  end

  def average_items_per_merchant_standard_deviation
    merchant_ids
    items_count_list
    list = items_count_list # list = items_count_list.sample(5)
    mean = list.sum.to_f / list.size
    sum = list.sum {|num| (num - mean)**2}
    sd = (Math.sqrt(sum / (list.size - 1))).round(2)
  end

  def merchant_ids
    @merch_ids = @merchant_repository.all.map {|merchant| merchant.id}
  end

  def items_count_list
    items_list = @merch_ids.map {|id| @item_repository.find_all_by_merchant_id(id).count}
  end

  def merchants_with_high_item_count
    sd = average_items_per_merchant_standard_deviation
    high_sellers = merchant_ids.find_all do |id|
      @item_repository.find_all_by_merchant_id(id).count > (sd + average_items_per_merchant)
    end
    high_seller_merchants = high_sellers.map {|seller| @merchant_repository.find_by_id(seller)}
  end

  def average_item_price_for_merchant(merchant_id)
    items = @item_repository.find_all_by_merchant_id(merchant_id)
    prices = items.map {|item| item.unit_price_to_dollars}
    (prices.sum/items.count).round(2)
  end

  def average_average_price_per_merchant
    averages = merchant_ids.map {|merchant_id| average_item_price_for_merchant(merchant_id)}
    (averages.sum / averages.count).floor(2)
  end

  def golden_items
    prices = @item_repository.all.map {|item| item.unit_price_to_dollars}
    @item_repository.all.find_all {|item| item.unit_price_to_dollars > (prices.sum / prices.size + sd_prices * 2)}
  end

  def sd_prices
    prices = @item_repository.all.map {|item| item.unit_price_to_dollars}
    mean = prices.sum / prices.size
    sum = prices.sum {|num| (num - mean)**2}
    price_sd = (Math.sqrt(sum / (prices.size - 1))).round(2)
  end

  def average_invoices_per_merchant
    (@invoice_repository.all.length.to_f / @merchant_repository.all.length).round(2)
  end

  def invoices_count_list
    invoices_list = @merch_ids.map {|id| @invoice_repository.find_all_by_merchant_id(id).count}
  end

  def average_invoices_per_merchant_standard_deviation
    merchant_ids
    invoices_count_list
    list = invoices_count_list
    mean = list.sum.to_f / list.size
    sum = list.sum {|num| (num - mean)**2}
    sd = (Math.sqrt(sum / (list.size - 1))).round(2)
  end

  def top_merchants_by_invoice_count
    sd = average_invoices_per_merchant_standard_deviation
    high_merchants = merchant_ids.find_all do |id|
      @invoice_repository.find_all_by_merchant_id(id).count > ((sd * 2) + average_invoices_per_merchant)
    end
    high_invoice_merchants = high_merchants.map {|merchant| @merchant_repository.find_by_id(merchant)}
  end

  def bottom_merchants_by_invoice_count
    sd = average_invoices_per_merchant_standard_deviation
    low_merchants = merchant_ids.find_all do |id|
      @invoice_repository.find_all_by_merchant_id(id).count < ((sd * -2) + average_invoices_per_merchant)
    end
    low_invoice_merchants = low_merchants.map {|merchant| @merchant_repository.find_by_id(merchant)}
  end

  def day_of_week
    new_date_format = []
    CSV.foreach(@invoice_repository.file_path, headers: true, header_converters: :symbol) do |row|
      new_date_format << row[:created_at].split("-")
    end
    days_of_week = new_date_format.map do |date|
      Time.new(date[0].to_i, date[1].to_i, date[2].to_i).wday
    end
  end

  def average_invoices_per_day_standard_deviation
    @tally = day_of_week.tally
    @mean = @tally.values.sum / 7.to_f
    list = @tally.values
    sum = list.sum {|num| (num - @mean)**2}
    @sd = (Math.sqrt(sum / (list.size - 1))).round(2)
  end

  def top_days_by_invoice_count
    day_of_week
    average_invoices_per_day_standard_deviation
    top_day =[]
    @tally.each do |day, total|
      if total > (@mean + @sd)
        top_day << day
      end
    end
    top_day
    # best_day(top_day)
  end

  # def best_day(day)
  #   days = {0 => "Sunday",
  #           1 => "Monday",
  #           2 => "Tuesday",
  #           3 => "Wednesday",
  #           4 => "Thursday",
  #           5 => "Friday",
  #           6 => "Saturday"}
  #
  #   top = days[day]
  #
  # end

  def invoice_status(status)
    ((@invoice_repository.find_all_by_status(status).count / @invoice_repository.all.count.to_f) * 100).round(2)
  end

  def invoice_paid_in_full?(id)
    transactions = @transaction_repository.find_all_by_invoice_id(id)
    if transactions == []
      return false
    else
      transactions.all? do |transaction|
        transaction.result == :success
      end
    end
  end

  def invoice_total(id)
    transactions = @invoice_item_repository.find_all_by_invoice_id(id)
    amounts = transactions.map do |transaction|
      transaction.quantity * transaction.unit_price
    end
    amounts.sum.to_f
  end

  def total_revenue_by_date(date)
    invoice_items = @invoice_item_repository.all.find_all { |invoice_item| invoice_item.created_at[0..9] == date.to_s[0..9] }
    amounts = invoice_items.map { |ii|
      ii.quantity * ii.unit_price }
    amounts.sum.to_f
  end

  def top_revenue_earners(number = 20)
    merchant_ids
    merchant_invoice_hash
    invoice_item_hash
    invoice_item_totals
    merchant_invoice_totals_sorted
    top_performing_merchant_ids(number)
    top_performing_merchants_array
    # @merch_ids = []
    # @sorted_totals.each do |total|
    #   if @sorted_totals.index(total) < number
    #     @merch_ids << total[0]
    #   end
    # end
    # answer = @merch_ids.flat_map do |merch_id|
    #   @merchant_repository.all.find_all {|merch| merch.id == merch_id}
    # end
  end

  def merchant_ids
    @merchants = @merchant_repository.all.map { |merchant| merchant.id }
  end

  def merchant_invoice_hash
    @merchant_invoices = {}
    @merchants.each do |merch|
      @merchant_invoices[merch] = @invoice_repository.all.find_all {|invoice| invoice.merchant_id == merch }
    end
  end

  def invoice_item_hash
    @ii = Hash.new {|hash, key| hash[key] = []}
    @merchant_invoices.each do |merch_id, invoices|
      invoices.each do |invoice|
        @ii[merch_id] << @invoice_item_repository.all.find_all { |invoice_item| invoice_item.invoice_id == invoice.id }
      end
    end
  end

  def invoice_item_totals
    @totals = Hash.new {|hash, key| hash[key] = []}
    @ii.each do |merch_id, inv_item_collection|
      inv_item_collection.each do |inv_items|
        inv_items.each do |inv_item|
          @totals[merch_id] << inv_item.quantity * inv_item.unit_price
        end
      end
    end
  end

  def merchant_invoice_totals_sorted
    @merchant_totals = Hash.new
    @totals.each do |merch_id, array|
      @merchant_totals[merch_id] = array.sum.to_f
    end
    @sorted_totals = @merchant_totals.sort_by do |merchant_id, total|
      -total
    end
  end

  def top_performing_merchant_ids(number)
    @merch_ids = []
    @sorted_totals.each do |total|
      if @sorted_totals.index(total) < number
        @merch_ids << total[0]
      end
    end
  end

  def top_performing_merchants_array
    answer = @merch_ids.flat_map do |merch_id|
      @merchant_repository.all.find_all {|merch| merch.id == merch_id}
    end
  end
end
