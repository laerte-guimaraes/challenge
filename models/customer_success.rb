class CustomerSuccess
  attr_reader :id, :score, :customers, :available

  @@all_customer_successes = []

  def initialize(id:, score:, available: true)
    @id = id
    @score = score
    @available = available
    @customers = []
    @@all_customer_successes << self
  end

  def associate_customer(customer)
    customers << customer
    customer.associate_customer_success(self)
  end

  def customers_count
    customers.count
  end

  def self.all
    @@all_customer_successes
  end

  def self.away
    @@all_customer_successes.select { |customer_success| !customer_success.available }
  end

  def self.available
    @@all_customer_successes.select { |customer_success| customer_success.available }
  end

  def self.reset_all
    @@all_customer_successes = []
  end
end
