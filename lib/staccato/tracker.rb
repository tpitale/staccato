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
    # @param hit_defaults [Hash]
    def initialize(id, client_id = nil, options = {})
      @id = id
      @client_id = client_id
      @ssl = options.delete(:ssl) || false
      @adapters = []

      self.hit_defaults = options
    end

    def adapter=(adapter)
      @adapters = [adapter]
    end

    def add_adapter(adapter)
      @adapters << adapter
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

    # Build a pageview
    # 
    # @param options [Hash] options include:
    #   * path (optional) the path of the current page view
    #   * hostname (optional) the hostname of the current page view
    #   * title (optional) the page title
    # @return [Pageview]
    def build_pageview(options = {})
      Staccato::Pageview.new(self, options)
    end

    # Track a pageview
    # 
    # @param options [Hash] options include:
    #   * path (optional) the path of the current page view
    #   * hostname (optional) the hostname of the current page view
    #   * title (optional) the page title
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def pageview(options = {})
      build_pageview(options).track!
    end

    def build_screenview(options = {})
      Staccato::Screenview.new(self, options)
    end

    def screenview(options = {})
      build_screenview(options).track!
    end

    # Build an event
    # 
    # @param options [Hash] options include:
    #   * category (optional)
    #   * action (optional)
    #   * label (optional)
    #   * value (optional)
    # @return [Event]
    def build_event(options = {})
      Staccato::Event.new(self, options)
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
      build_event(options).track!
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

    # Build an ecommerce transaction
    #
    # @return [Transaction]
    def build_transaction(options = {})
      Staccato::Transaction.new(self, options)
    end

    # Track an ecommerce transaction
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def transaction(options = {})
      build_transaction(options).track!
    end

    # Build an item in an ecommerce transaction
    #
    # @return [TransactionItem]
    def build_transaction_item(options = {})
      Staccato::TransactionItem.new(self, options)
    end

    # Track an item in an ecommerce transaction
    # @return [<Net::HTTPOK] the GA `/collect` endpoint always returns a 200
    def transaction_item(options = {})
      build_transaction_item(options).track!
    end

    # post the hit to GA collection endpoint
    # @return [Net::HTTPOK] the GA api always returns 200 OK
    def track(params={})
      post(params)
    end

    def default_uri
      Staccato.ga_collection_uri(@ssl)
    end

    private

    # @private
    def single_adapter?
      adapters.length == 1
    end

    # @private
    def post(params)
      single_adapter? ? post_first(params) : post_all(params)
    end

    # @private
    def post_first(params)
      adapters.first.post(params)
    end

    # @private
    def post_all(params)
      adapters.map {|adapter| adapter.post(params)}
    end

    # @private
    def adapters
      @adapters.empty? ? [default_adapter] : @adapters
    end

    # @private
    def default_adapter
      @default_adapter ||= Staccato.default_adapter.new(default_uri)
    end
  end

  # A tracker which does no tracking
  #   Useful in testing
  class NoopTracker
    attr_accessor :hit_defaults

    # (see Tracker#initialize)
    def initialize(id = nil, client_id = nil, hit_defaults = {})
      self.hit_defaults = hit_defaults
    end

    def adapter=(*)
      []
    end

    def add_adapter(*)
      []
    end

    # (see Tracker#id)
    def id
      nil
    end

    # (see Tracker#client_id)
    def client_id
      nil
    end

    # (see Tracker#build_pageview)
    def build_pageview(options = {}); end
    # (see Tracker#pageview)
    def pageview(options = {}); end
    # (see Tracker#build_event)
    def build_event(options = {}); end
    # (see Tracker#event)
    def event(options = {}); end
    # (see Tracker#social)
    def social(options = {}); end
    # (see Tracker#exception)
    def exception(options = {}); end
    # (see Tracker#timing)
    def timing(options = {}, &block)
      yield if block_given?
    end
    # (see Tracker#transaction)
    def transaction(options = {})
    end
    # (see Tracker#transaction_item)
    def transaction_item(options = {})
    end

    # (see Tracker#track)
    def track(params = {})
    end

    def default_uri
      Staccato.ga_collection_uri
    end
  end
end
