require_relative '../models/customer'

class CustomerSuccessBalancing
  class Customers
    attr_reader :customers

    def initialize(customers:)
      @customers = customers
    end

    def fetch
      customers.map do |customer|
        Customer.new(id: customer[:id], score: customer[:score])
      end.sort_by(&:score)
    end
  end
end
