require_relative 'customer_success_balacing/validations'
require_relative 'customer_success_balacing/customers'
require_relative 'customer_success_balacing/customer_successes'

class CustomerSuccessBalancing
  include Validations

  attr_reader :customer_successes, :customers, :away_customer_successes, :customer_successes_size

  def initialize(customer_successes, customers, away_customer_successes)
    Customers.new(customers:).fetch
    @customers = Customer.all

    CustomerSuccesses.new(customer_successes:, away_customer_successes:).fetch
    @customer_successes = CustomerSuccess.available.sort_by(&:score)
  end

  # Returns the ID of the customer success with most customers or ZERO
  def execute
    return 0 unless valid?

    split_customers_for_customer_successes
    customer_success_id_with_more_customers
  end

  private

  def split_customers_for_customer_successes
    customers.each do |customer|
      customer_successes.each do |customer_success|
        # Customer already taken by an Customer Success
        next if customer.customer_success

        # Customer score greather than Customer Success score
        next if customer.score > customer_success.score

        customer_success.associate_customer(customer)
      end
    end
  end

  def customer_success_id_with_more_customers
    # Sort by `customers count` greater first
    sorted_customer_successes = customer_successes.sort_by(&:customers_count).reverse!

    if sorted_customer_successes[0].customers.count == sorted_customer_successes[1].customers.count
      0 # Draw
    else
      sorted_customer_successes[0].id # Winner
    end
  end
end
