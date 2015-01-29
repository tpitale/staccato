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
    # @param query_string [String] URL params for custom dimensions/metrics and enhanced e-commerce tracking
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def pageview(options = {}, query_string = '')
      Staccato::Pageview.new(self, options, query_string).track!
    end

    # Track an event
    #
    # @param options [Hash] options include:
    #   * category (optional)
    #   * action (optional)
    #   * label (optional)
    #   * value (optional)
    # @param query_string [String] URL params for custom dimensions/metrics and enhanced e-commerce tracking
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def event(options = {}, query_string = '')
      Staccato::Event.new(self, options, query_string).track!
    end

    # Track a screen view
    #
    # @param options [Hash] options include:
    #   * name (optional)
    #   * version (optional)
    #   * id (optional)
    #   * installer_id (optional)
    #   * content_description (optional)
    # @param query_string [String] URL params for custom dimensions/metrics and enhanced e-commerce tracking
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def screen(options = {}, query_string = '')
      Staccato::Screen.new(self, options, query_string).track!
    end

    # Track a social event such as a Facebook Like or Twitter Share
    #
    # @param options [Hash] options include:
    #   * action (required) the action taken, e.g., 'like'
    #   * network (required) the network used, e.g., 'facebook'
    #   * target (required) the target page path, e.g., '/blog/something-awesome'
    # @param query_string [String] URL params for custom dimensions/metrics and enhanced e-commerce tracking
    # @param query_string [String] URL params for custom dimensions/metrics and enhanced e-commerce tracking
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def social(options = {}, query_string = '')
      Staccato::Social.new(self, options, query_string).track!
    end

    # Track an exception
    #
    # @param options [Hash] options include:
    #   * description (optional) often the class of exception, e.g., RuntimeException
    #   * fatal (optional) was the exception fatal? boolean, defaults to false
    # @param query_string [String] URL params for custom dimensions/metrics and enhanced e-commerce tracking
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def exception(options = {}, query_string = '')
      Staccato::Exception.new(self, options, query_string).track!
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
    # @param query_string [String] URL params for custom dimensions/metrics and enhanced e-commerce tracking
    # @param block [#call] if a block is provided, the time it takes to
    #   run will be recorded and set as the `time` value option, no other
    #   time values will be set.
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def timing(options = {}, query_string = '', &block)
      Staccato::Timing.new(self, options, query_string).track!(&block)
    end

    # Track an ecommerce transaction
    # @param query_string [String] URL params for custom dimensions/metrics and enhanced e-commerce tracking
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def transaction(options = {}, query_string = '')
      Staccato::Transaction.new(self, options, query_string).track!
    end

    # Track an item in an ecommerce transaction
    # @param query_string [String] URL params for custom dimensions/metrics and enhanced e-commerce tracking
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def transaction_item(options = {}, query_string = '')
      Staccato::TransactionItem.new(self, options, query_string).track!
    end

    # post the hit to GA collection endpoint
    # @return [Net::HTTPOK] the GA api always returns 200 OK
    def track(params={})
      post(Staccato.tracking_uri, params)
    end

    private

    # @private
    def post(uri, params)
      puts params
      Net::HTTP.post_form(uri, params)
    end
  end

  # A tracker which does no tracking
  #   Useful in testing
  class NoopTracker
    # (see Tracker#initialize)
    def initialize(*); end

    def hit_defaults
      {}
    end

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

    def track(*)
    end
  end
end
