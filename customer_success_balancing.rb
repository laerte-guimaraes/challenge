require 'minitest/autorun'
require 'timeout'
require_relative 'customer_success_balacing/available_customer_successes'
require_relative 'customer_success_balacing/customers'

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

class CustomerSuccessBalancingTests < Minitest::Test
  def test_scenario_one
    balancer = CustomerSuccessBalancing.new(
      build_scores([60, 20, 95, 75]),
      build_scores([90, 20, 70, 40, 60, 10]),
      [2, 4]
    )
    assert_equal 1, balancer.execute
  end

  def test_scenario_two
    balancer = CustomerSuccessBalancing.new(
      build_scores([11, 21, 31, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_three
    balancer = CustomerSuccessBalancing.new(
      build_scores(Array(1..999)),
      build_scores(Array.new(10000, 998)),
      [999]
    )
    result = Timeout.timeout(1.0) { balancer.execute }
    assert_equal 998, result
  end

  def test_scenario_four
    balancer = CustomerSuccessBalancing.new(
      build_scores([1, 2, 3, 4, 5, 6]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_five
    balancer = CustomerSuccessBalancing.new(
      build_scores([100, 2, 3, 6, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 1, balancer.execute
  end

  def test_scenario_six
    balancer = CustomerSuccessBalancing.new(
      build_scores([100, 99, 88, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      [1, 3, 2]
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_seven
    balancer = CustomerSuccessBalancing.new(
      build_scores([100, 99, 88, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      [4, 5, 6]
    )
    assert_equal 3, balancer.execute
  end

  def test_scenario_eight
    balancer = CustomerSuccessBalancing.new(
      build_scores([60, 40, 95, 75]),
      build_scores([90, 70, 20, 40, 60, 10]),
      [2, 4]
    )
    assert_equal 1, balancer.execute
  end

  private

  def build_scores(scores)
    scores.map.with_index do |score, index|
      { id: index + 1, score: score }
    end
  end
end
