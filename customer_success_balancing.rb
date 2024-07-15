require 'minitest/autorun'
require_relative 'customer_success_balacing/customers'
require_relative 'customer_success_balacing/available_customer_successes'

class CustomerSuccessBalancing
  attr_reader :customer_successes, :customers, :away_customer_successes

  def initialize(customer_successes, customers, away_customer_successes)
    @away_customer_successes = away_customer_successes
    @customers = Customers.new(customers:).fetch
    @customer_successes = AvailableCustomerSuccesses.new(
      customer_successes:,
      away_customer_successes:,
    ).fetch
  end

  # Returns the ID of the customer success with most customers or ZERO
  def execute
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
