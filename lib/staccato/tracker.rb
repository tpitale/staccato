module Staccato
  # The `Tracker` class has methods to create all `Hit` types
  # 
  # @author Tony Pitale
  class Tracker
    def initialize(id, client_id = nil)
      @id = id
      @client_id = client_id
    end

    # The tracker id for GA
    # @return [String, nil]
    def id
      @id
    end

    # The unique client id
    # @return [String]
    def client_id
      @client_id ||= Staccato.build_client_id
    end

    # Track a pageview
    # 
    # @param options [Hash] options include:
    #   * path (optional) the path of the current page view
    #   * hostname (optional) the hostname of the current page view
    #   * title (optional) the page title
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def pageview(options = {})
      Staccato::Pageview.new(self, options).track!
    end

    # Track an event
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def event(options = {})
      Staccato::Event.new(self, options).track!
    end

    # Track a social event
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def social(options = {})
      Staccato::Social.new(self, options).track!
    end

    # Track an exception
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def exception(options = {})
      Staccato::Exception.new(self, options).track!
    end

    # Track timing
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def timing(options = {}, &block)
      Staccato::Timing.new(self, options).track!(&block)
    end

    # Track an ecommerce transaction
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def transaction(options = {})
      Staccato::Transaction.new(self, options).track!
    end

    # Track an item in an ecommerce transaction
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def transaction_item(options = {})
      Staccato::TransactionItem.new(self, options).track!
    end
  end

  # A tracker which does no tracking
  #   Useful for using in tests
  class NoopTracker
    def initialize(*); end

    def id
      nil
    end

    def client_id
      nil
    end

    def pageview(*); end
    def event(*); end
    def social(*); end
    def exception(*); end
    def timing(*)
      yield if block_given?
    end
    def transaction(*)
    end
    def transaction_item(*)
    end
  end
end
