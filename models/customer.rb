class Customer
  attr_reader :id, :score
  attr_accessor :customer_success

  def initialize(id:, score:)
    @id = id
    @score = score
    @customer_success = nil
  end

  def associate_customer_success(customer_success)
    @customer_success = customer_success
  end
end
