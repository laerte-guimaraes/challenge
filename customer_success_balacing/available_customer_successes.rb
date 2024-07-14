require_relative '../models/customer_success'

class CustomerSuccessBalancing
  class AvailableCustomerSuccesses
    attr_reader :customer_successes, :away_customer_successes

    def initialize(customer_successes:, away_customer_successes:)
      @customer_successes = customer_successes
      @away_customer_successes = away_customer_successes
    end

    def fetch
      customer_successes.map do |cs|
        # Skip away Customer Successes
        next if away_customer_successes.include?(cs[:id])

        CustomerSuccess.new(id: cs[:id], score: cs[:score])
      end.compact.sort_by(&:score)
    end
  end
end
