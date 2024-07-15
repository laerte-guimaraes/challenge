require_relative '../models/customer'

class CustomerSuccessBalancing
  class Customers
    attr_reader :customers

    def initialize(customers:)
      @customers = customers
    end

    def fetch
      Customer.reset_all

      customers.map do |customer|
        Customer.new(id: customer[:id], score: customer[:score])
      end
    end
  end
end
