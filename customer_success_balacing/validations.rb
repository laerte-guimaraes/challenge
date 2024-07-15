require_relative '../models/customer'

class CustomerSuccessBalancing
  module Validations
    def valid?
      customer_successes_has_different_scores? &&
        valid_customer_successes_size? &&
        valid_customers_size? &&
        valid_customer_success_ids? &&
        valid_customer_ids? &&
        valid_customer_success_scores? &&
        valid_customer_scores?
    end

    private

    def customer_successes_has_different_scores?
      customer_successes_score = customer_successes.map(&:score)

      customer_successes_score.size == customer_successes_score.uniq.size
    end

    def valid_customer_successes_size?
      customer_successes.size > 0 && customer_successes.size < 1_000
    end

    def valid_customers_size?
      customers.size > 0 && customers.size < 1_000_000
    end

    def valid_customer_success_ids?
      customer_success_ids = customer_successes.map(&:id).sort

      customer_success_ids.first > 0 && customer_success_ids.last < 1_000
    end

    def valid_customer_ids?
      customer_ids = customers.map(&:id).sort

      customer_ids.first > 0 && customer_ids.last < 1_000_000
    end

    def valid_customer_success_scores?
      customer_success_scores = customer_successes.map(&:score).sort

      customer_success_scores.last > 0 && customer_success_scores.last < 10_000
    end

    def valid_customer_scores?
      customer_scores = customers.map(&:score).sort

      customer_scores.last > 0 && customer_scores.last < 100_000
    end

    def valid_maximum_away_customer_successes?
      away_customer_successes.size <= (customer_successes_size / 2).floor
    end
  end
end
