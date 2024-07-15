require 'minitest/autorun'
require 'timeout'
require_relative '../customer_success_balancing'
require 'byebug'

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

  def test_customer_successes_has_different_scores
    balancer = CustomerSuccessBalancing.new(
      build_scores([10, 20, 20, 40]),
      build_scores([10, 20, 30, 40]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_empty_customer_successes
    balancer = CustomerSuccessBalancing.new(
      [],
      build_scores([10]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_customer_successes_smaller_than_1_000
    balancer = CustomerSuccessBalancing.new(
      build_scores(Array.new(1_000)),
      build_scores([10]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_empty_customers
    balancer = CustomerSuccessBalancing.new(
      build_scores([10]),
      [],
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_customers_smaller_than_1_000_000
    balancer = CustomerSuccessBalancing.new(
      build_scores([100]),
      build_scores(Array.new(1_000_000)),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_customer_success_id_zero
    balancer = CustomerSuccessBalancing.new(
      [{ id: 0, score: 100 }],
      build_scores([100]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_customer_success_ids_smaller_than_1_000
    balancer = CustomerSuccessBalancing.new(
      [{ id: 1_000, score: 100 }],
      build_scores([100]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_customer_id_zero
    balancer = CustomerSuccessBalancing.new(
      build_scores([100]),
      [{ id: 0, score: 100 }],
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_customer_ids_smaller_than_1_000_000
    balancer = CustomerSuccessBalancing.new(
      build_scores([100]),
      [{ id: 1_000_000, score: 100 }],
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_customer_success_score_zero
    balancer = CustomerSuccessBalancing.new(
      [{ id: 1, score: 0 }],
      build_scores([100]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_customer_success_score_greater_than_9_999
    balancer = CustomerSuccessBalancing.new(
      [{ id: 1, score: 10_000 }],
      build_scores([100]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_customer_score_zero
    balancer = CustomerSuccessBalancing.new(
      build_scores([100]),
      [{ id: 1, score: 0 }],
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_customer_score_greater_than_99_999
    balancer = CustomerSuccessBalancing.new(
      build_scores([100]),
      [{ id: 1, score: 100_000 }],
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_maximum_away_customer_successes
    balancer = CustomerSuccessBalancing.new(
      build_scores([100]),
      build_scores([10]),
      [1],
    )
    assert_equal 0, balancer.execute
  end

  private

  def build_scores(scores)
    scores.map.with_index do |score, index|
      { id: index + 1, score: score }
    end
  end
end
