module Staccato
  # The `Tracker` class has methods to create all `Hit` types
  #   using the tracker and client id
  # 
  # @author Tony Pitale
  class Tracker
    attr_accessor :hit_defaults

    # sets up a new tracker
    # @param id [String] the GA tracker id
    # @param client_id [String, nil] unique value to track user sessions
    def initialize(id, client_id = nil, hit_defaults = {})
      @id = id
      @client_id = client_id

      self.hit_defaults = hit_defaults
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
    # 
    # @param options [Hash] options include:
    #   * category (optional)
    #   * action (optional)
    #   * label (optional)
    #   * value (optional)
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def event(options = {})
      Staccato::Event.new(self, options).track!
    end

    # Track a social event such as a Facebook Like or Twitter Share
    # 
    # @param options [Hash] options include:
    #   * action (required) the action taken, e.g., 'like'
    #   * network (required) the network used, e.g., 'facebook'
    #   * target (required) the target page path, e.g., '/blog/something-awesome'
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def social(options = {})
      Staccato::Social.new(self, options).track!
    end

    # Track an exception
    # 
    # @param options [Hash] options include:
    #   * description (optional) often the class of exception, e.g., RuntimeException
    #   * fatal (optional) was the exception fatal? boolean, defaults to false
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def exception(options = {})
      Staccato::Exception.new(self, options).track!
    end

    # Track timing
    # 
    # @param options [Hash] options include:
    #   * category (optional) e.g., 'runtime'
    #   * variable (optional) e.g., 'database'
    #   * label (optional) e.g., 'query'
    #   * time (recommended) the integer time in milliseconds
    #   * page_load_time (optional)
    #   * dns_time (optional)
    #   * page_download_time (optional)
    #   * redirect_response_time (optional)
    #   * tcp_connect_time (optional)
    #   * server_response_time (optional) most useful on the server-side
    # @param block [#call] if a block is provided, the time it takes to
    #   run will be recorded and set as the `time` value option, no other
    #   time values will be set.
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
  #   Useful in testing
  class NoopTracker
    # (see Tracker#initialize)
    def initialize(*); end

    # (see Tracker#id)
    def id
      nil
    end

    # (see Tracker#client_id)
    def client_id
      nil
    end

    # (see Tracker#pageview)
    def pageview(*); end
    # (see Tracker#event)
    def event(*); end
    # (see Tracker#social)
    def social(*); end
    # (see Tracker#exception)
    def exception(*); end
    # (see Tracker#timing)
    def timing(*)
      yield if block_given?
    end
    # (see Tracker#transaction)
    def transaction(*)
    end
    # (see Tracker#transaction_item)
    def transaction_item(*)
    end
  end
end
