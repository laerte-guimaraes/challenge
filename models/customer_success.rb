class CustomerSuccess
  attr_reader :id, :score, :customers

  def initialize(id:, score:)
    @id = id
    @score = score
    @customers = []
  end

  def associate_customer(customer)
    customers << customer
    customer.associate_customer_success(self)
  end

  def customers_count
    customers.count
  end
end
