class MerchantRepository
  attr_reader :file_path, :all, :find_by_id


  def initialize(file_path)
    @file_path = file_path
    @all = []

    CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      @all << Merchant.new(:id =>row[:id],:name => row[:name])
    end

  end

  def find_by_id(id)
    @all.find do |row|
      row.id == id
    
    end
  end


end
