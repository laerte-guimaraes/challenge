require_relative '../models/customer_success'

class CustomerSuccessBalancing
  class CustomerSuccesses
    attr_reader :customer_successes, :away_customer_successes

    def initialize(customer_successes:, away_customer_successes:)
      @customer_successes = customer_successes
      @away_customer_successes = away_customer_successes
    end

    def fetch
      CustomerSuccess.reset_all

      customer_successes.map do |cs|
        CustomerSuccess.new(
          id: cs[:id],
          score: cs[:score],
          available: !away_customer_successes.include?(cs[:id]) # `False` for away Customer Success
        )
      end
    end
  end
end
