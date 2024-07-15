class Customer
  attr_reader :id, :score
  attr_accessor :customer_success

  @@all_customers = []

  def initialize(id:, score:)
    @id = id
    @score = score
    @customer_success = nil
    @@all_customers << self
  end

  def associate_customer_success(customer_success)
    @customer_success = customer_success
  end

  def self.all
    @@all_customers
  end

  def self.reset_all
    @@all_customers = []
  end
end
