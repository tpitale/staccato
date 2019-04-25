# Staccato

Ruby library to track into the official Google Analytics Measurement Protocol

https://developers.google.com/analytics/devguides/collection/protocol/v1/

**NOTE:** The Measurement Protocol is part of Universal Analytics, which is currently available in public beta. Data from the measurement protocol will only be processed in Universal Analytics enabled properties.

[![Gem Version](https://badge.fury.io/rb/staccato.png)](http://badge.fury.io/rb/staccato)
[![Build Status](https://travis-ci.org/tpitale/staccato.png?branch=master)](https://travis-ci.org/tpitale/staccato)
[![Code Climate](https://codeclimate.com/github/tpitale/staccato.png)](https://codeclimate.com/github/tpitale/staccato)

If you're using Rails and would like to use Staccato, we have an gem for that! [Staccato Rails](https://github.com/tpitale/staccato-rails)


## Installation

Add this line to your application's Gemfile:

    gem 'staccato'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install staccato

## Usage ##

```ruby
tracker = Staccato.tracker('UA-XXXX-Y') # REQUIRED, your Google Analytics Tracking ID
```

`#tracker` optionally takes a second param for the `client_id` value.
By default, the `client_id` is set to a random UUID with `SecureRandom.uuid`

### Setting SSL on a tracker ###

```ruby
# passing nil as the second argument lets Staccato build the client id, as the default
tracker = Staccato.tracker('UA-XXXX-Y', nil, ssl: true)
```

### Track some data ###

```ruby
# Track a Pageview (all values optional)
tracker.pageview(path: '/page-path', hostname: 'mysite.com', title: 'A Page!')

# Track an Event (all values optional)
tracker.event(category: 'video', action: 'play', label: 'cars', value: 1)

# Track social activity (all values REQUIRED)
tracker.social(action: 'like', network: 'facebook', target: '/something')

# Track exceptions (all values optional)
tracker.exception(description: 'RuntimeException', fatal: true)

# Track timing (all values optional, but should include time)
tracker.timing(category: 'runtime', variable: 'db', label: 'query', time: 50) # time in milliseconds

tracker.timing(category: 'runtime', variable: 'db', label: 'query') do
  some_code_here
end

# Track transaction (transaction_id REQUIRED)
tracker.transaction({
  transaction_id: 12345,
  affiliation: 'clothing',
  revenue: 17.98,
  shipping: 2.00,
  tax: 2.50,
  currency: 'EUR'
})

# Track transaction item (matching transaction_id and item name REQUIRED)
tracker.transaction_item({
  transaction_id: 12345,
  name: 'Shirt',
  price: 8.99,
  quantity: 2,
  code: 'afhcka1230',
  variation: 'red',
  currency: 'EUR'
})
```

### Building Hits ###

If you need access to a hit, you can use `tracker.build_<hit type>` and pass it the same options as the above tracker methods. For example, these are all the same:

```ruby
# build and track a Staccato::Pageview in a single step
tracker.pageview(options_hash)

# build, and then track, a pageview
tracker.build_pageview(options_hash).track!

# build a Staccato::Pageview, then track it
hit = Staccato::Pageview.new(tracker, options_hash)
hit.track!
```

### "Global" Options ###

Any of the options on the parameters list (https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters) that are accepted on ALL hit types can be set as options on any of the hits.

```ruby
tracker.pageview(path: '/video/1235', flash_version: 'v1.2.3')
```

Flash Version is a global option in the example above.

**Note:** There are a few options that if used will override global options:

* document_path: overriden by `path` in pageviews
* document_hostname: overriden by `hostname` in pageviews
* document_title: overriden by `title` in pageviews

These are holdovers from the original design, where `pageview` is a hit type that can take any/all of the optional parameters. `path`, `hostname`, and `title` are slightly nicer to use on `pageview`.

The complete list at this time:

```ruby
Staccato::Hit::GLOBAL_OPTIONS.keys # =>

[:anonymize_ip,
 :queue_time,
 :data_source,
 :cache_buster,
 :user_id,
 :user_ip,
 :user_agent,
 :referrer,
 :campaign_name,
 :campaign_source,
 :campaign_medium,
 :campaign_keyword,
 :campaign_content,
 :campaign_id,
 :adwords_id,
 :display_ads_id,
 :screen_resolution,
 :viewport_size,
 :screen_colors,
 :user_language,
 :java_enabled,
 :flash_version,
 :document_location,
 :document_encoding,
 :document_hostname,
 :document_path,
 :document_title,
 :link_id,
 :application_name,
 :application_version,
 :application_id,
 :application_installer_id,
 :experiment_id,
 :experiment_variant,
 :product_action,
 :product_action_list,
 :promotion_action,
 :geographical_id]
```

Boolean options like `anonymize_ip` will be converted from `true`/`false` into `1`/`0` as per the tracking API docs.

The `data_source` option can take any value, but note that hits sent from other Google tools will have specific values.  Hits sent from analytics.js will have `data_source` set to `web`, and hits sent from one of the mobile SDKs will have `data_source` set to `app`.

#### Custom Dimensions and Metrics ####

```ruby
hit = Staccato::Pageview.new(tracker, hostname: 'mysite.com', path: '/sports-page-5', title: 'Sports Page #5')
hit.add_custom_dimension(19, 'Sports')
hit.add_custom_metric(2, 5)
hit.track!
```

The first argument is the slot position. Custom dimensions and metrics have 20 slots or 200 if you're "Premium" account.

The second argument is the value. For dimensions, that's a text value. For metrics it is an integer.

#### Non-Interactive Hit ####

```ruby
# Track a Non-Interactive Hit
tracker.event(category: 'video', action: 'play', non_interactive: true)
```

Non-Interactive events are useful for tracking things like emails sent, or other
events that are not directly the result of a user's interaction.

The option `non_interactive` is accepted for all methods on `tracker`.

#### Session Control ####

```ruby
# start a session
tracker.pageview(path: '/blog', start_session: true)

# end a session
tracker.pageview(path: '/blog', end_session: true)
```

Other options are acceptable to start and end a session: `session_start`, `session_end`, and `stop_session`.

#### Content Experiment ####

```ruby
# Tracking an Experiment
#   useful for tracking A/B or Multivariate testing
tracker.pageview({
  path: '/blog',
  experiment_id: 'a7a8d91df',
  experiment_variant: 'a'
})
```

## Tracker Hit Defaults ##

Global parameters can be set as defaults on the tracker, and will be used for all hits (unless overwritten by parameters set directly on a hit).

The following example creates a tracker with a default hostname. The two pageviews will track the default hostname and the page path passed in.

```ruby
tracker = Staccato.tracker('UA-XXXX-Y', client_id, {document_hostname: 'example.com'})

tracker.pageview(path: '/videos/123')
tracker.pageview(path: '/videos/987')
```

## Additional Measurements ##

Additional Measurements can be added to any Hit type, but most commonly used with pageviews or events. The current set of measurements is for handling [Enhanced Ecommerce](https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide#enhancedecom) measurements. I've grouped these into ImpressionList, Product, ProductImpression, Promotion, Transaction, Checkout, and CheckoutOption (w/ ImpressionList). Each can be added and combined – per Google's documentation – onto an existing Hit.

**Note:** Certain Measurements require an `index`. This is an integer (usually) between 1 and 200 inclusive.

**Note:** Certain Measurements require a `product_action` to be set. This is a global option, and should be set on the original hit. The `product_action` can be any one of:

* `detail`
* `click`
* `add`
* `remove`
* `checkout`
* `checkout_option`
* `purchase`
* `refund`

### Transaction w/ Product ###

Using a pageview to track a transaction with a product (using the 'purchase' as the `product_action`:

```ruby
pageview = tracker.build_pageview(path: '/receipt', hostname: 'mystore.com', title: 'Your Receipt', product_action: 'purchase')

pageview.add_measurement(:transaction, {
  transaction_id: 'T12345',
  affiliation: 'Your Store',
  revenue: 37.39,
  tax: 2.85,
  shipping: 5.34,
  currency: 'USD',
  coupon_code: 'SUMMERSALE'
})

pageview.add_measurement(:product, {
  index: 1, # this is our first product, value may be 1-200
  id: 'P12345',
  name: 'T-Shirt',
  category: 'Apparel',
  brand: 'Your Brand',
  variant: 'Purple',
  quantity: 2,
  position: 1,
  price: 14.60,
  coupon_code: 'ILUVTEES'
})

pageview.track!
```

### Transaction Refund ###

The combination of `product_action: 'refund'` and `transaction` measurement setting a matching `id` to a previous transaction.

```ruby
event = tracker.build_event(category: 'order', action: 'refund', non_interactive: true, product_action: 'refund')

event.add_measurement(:transaction, transaction_id: 'T12345')

event.track!
```

### Transaction & Product Refund ###

The combination of `product_action: 'refund'` and `transaction` measurement setting a matching `id` to a previous transaction. You can also specify a product (or products, using `index`) with a `quantity` (for partial refunds) to refund.

```ruby
event = tracker.build_event(category: 'order', action: 'refund', non_interactive: true, product_action: 'refund')

event.add_measurement(:transaction, transaction_id: 'T12345')
event.add_measurement(:product, index: 1, id: 'P12345', quantity: 1)

event.track!
```

### Promotion Impression ###

```ruby
pageview = tracker.build_pageview(path: '/search', hostname: 'mystore.com', title: 'Search Results')

pageview.add_measurement(:promotion, {
  index: 1,
  id: 'PROMO_1234',
  name: 'Summer Sale',
  creative: 'summer_sale_banner',
  position: 'banner_1'
})

pageview.track!
```

### Promotion Click ###

Promotion also supports a `promotion_action`, similar to `product_action`. This is another global option on `Hit`.

```ruby
event = tracker.build_event(category: 'promotions', action: 'click', label: 'internal', promotion_action: 'click')

event.add_measurement(:promotion, {
  index: 1,
  id: 'PROMO_1234',
  name: 'Summer Sale',
  creative: 'summer_sale_banner',
  position: 'banner_1'
})

event.track!
```

### Product Click ###

```ruby
event = tracker.build_event(category: 'search', action: 'click', label: 'results', product_action: 'click', product_action_list: 'Search Results')

event.add_measurement(:product, {
  index: 1,
  id: 'P12345',
  name: 'T-Shirt',
  category: 'Apparel',
  brand: 'Your Brand',
  variant: 'Purple',
  quantity: 2,
  position: 1,
  price: 14.60,
  coupon_code: 'ILUVTEES'
})

event.track!
```

### Checkout ###

```ruby
pageview = tracker.build_pageview(path: '/checkout', hostname: 'mystore.com', title: 'Complete Your Checkout', product_action: 'checkout')

pageview.add_measurement(:product, {
  index: 1, # this is our first product, value may be 1-200
  id: 'P12345',
  name: 'T-Shirt',
  category: 'Apparel',
  brand: 'Your Brand',
  variant: 'Purple',
  quantity: 2,
  position: 1,
  price: 14.60,
  coupon_code: 'ILUVTEES'
})

pageview.add_measurement(:checkout, {
  step: 1,
  step_option: 'Visa'
})

pageview.track!
```

### Checkout Option ###

```ruby
event = tracker.build_event(category: 'checkout', action: 'option', non_interactive: true, product_action: 'checkout_option')

event.add_measurement(:checkout_options, {
  step: 2,
  step_option: 'Fedex'
})

event.track!
```

### Impression List & Product Impression ###

```ruby
pageview = tracker.build_pageview(path: '/home', hostname: 'mystore.com', title: 'Home Page')

pageview.add_measurement(:impression_list, index: 1, name: 'Search Results')

pageview.add_measurement(:product_impression, {
  index: 1,
  list_index: 1, # match the impression_list above
  id: 'P12345',
  name: 'T-Shirt',
  category: 'Apparel',
  brand: 'Your Brand',
  variant: 'Purple',
  position: 1,
  price: 14.60
})

pageview.add_measurement(:impression_list, index: 2, name: 'Recommendations')

pageview.add_measurement(:product_impression, {
  index: 1,
  list_index: 2,
  name: 'Yellow Tee'
})

pageview.add_measurement(:product_impression, {
  index: 2,
  list_index: 2,
  name: 'Red Tee'
})

pageview.track!
```

### Screenview (as in mobile) ###

```ruby
tracker.screenview({
  screen_name: 'user1'
})
```

## Google Documentation ##

https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide
https://developers.google.com/analytics/devguides/collection/protocol/v1/reference
https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters

## Adapters ##

Staccato provides a variety of adapters for sending or debugging requests being made. To use them, first require the adapter by name: `require 'staccato/adapter/#{chosen-adapter-name}'`

Multiple adapters can be used by calling `add_adapter`:

```ruby
require 'staccato/adapter/validate'

tracker = Staccato.tracker('UA-XXXX-Y') do |c|
  c.add_adapter Staccato::Adapter::Validate.new
  c.add_adapter Staccato::Adapter::Logger.new(Staccato.ga_collection_uri)
  c.add_adapter Staccato::Adapter::Faraday.new(Staccato.ga_collection_uri)
end
```

**Results returned will be in an array, as returned by each adapter in the order the adapters were added.**

### HTTP Adapters ###

Staccato provides a number of basic adapters to different ruby http libraries. By default, Staccato uses `net/http` when you create a new tracker. If you are using Faraday or [The Ruby HTTP library](https://github.com/httprb/http.rb) Staccato provides adapters.

```ruby
require 'staccato/adapter/faraday' # Faraday gem must be installed

tracker = Staccato.tracker('UA-XXXX-Y') do |c|
  c.adapter = Staccato::Adapter::Faraday.new(Staccato.ga_collection_uri) do |faraday|
    # further faraday configuration here
  end
end
```

You can also make your own Adapters by implementing any class that responds to `post` with a hash of params/data to be posted. The default adapters all accept the URI in the initializer, but this is not a requirement for yours.

One such example might be for a new `net/http` adapter which accepts more options for configuring the connection:

```ruby
class CustomAdapter
  attr_reader :uri

  def initialize(uri, options={})
    @uri = uri
    @options = options
  end

  def post(data)
    Net::HTTP::Post.new(uri.request_uri).tap do |request|
      request.read_timeout = @options.fetch(:read_timeout, 90)
      request.form_data = data

      execute(request)
    end
  end

  private
  def execute(request)
    Net::HTTP.new(uri.hostname, uri.port).start do |http|
      http.open_timeout = @options.fetch(:open_timeout, 90)
      http.request(request)
    end
  end
end
```

Which would be used like:

```ruby
tracker = Staccato.tracker('UA-XXXX-Y') do |c|
  c.adapter = CustomAdapter.new(Staccato.ga_collection_uri, read_timeout: 1, open_time: 1)
end
```

### Validation Adapter ###

The validation adapter sends hits to the debug endpoint, which responds with information about the validity of the hit.

```ruby
require 'staccato/adapter/validate'

tracker = Staccato.tracker('UA-XXXX-Y') do |c|
  c.adapter = Staccato::Adapter::Validate.new
end
```

See results by printing a call to track any hit:

```ruby
puts tracker.pageview(path: '/')
```

By default, the staccato `default_adapter` is used to send validation hits, but a different adapter can be used (e.g. `Faraday` or `Net::HTTP`).

```ruby
tracker = Staccato.tracker('UA-XXXX-Y') do |c|
  c.adapter = Staccato::Adapter::Validate.new(Staccato::Adapter::HTTP)
end
```

### UDP Adapter for Staccato::Proxy ###

If you're using [Staccato::Proxy](https://github.com/tpitale/staccato-proxy), you can point Staccato at it using the UDP adapter.

```ruby
require 'staccato/adapter/udp'

tracker = Staccato.tracker('UA-XXXX-Y') do |c|
  c.adapter = Staccato::Adapter::UDP.new(URI('udp://127.0.0.1:3003'))
end
```

Be sure to set the ip or host and port to wherever you have configured Staccato::Proxy to run.

### Logger Adapter for Local Development/Debugging ###

If you're running in development and simply want to make sure Staccato is being called where you expect it to be. Or, if you want to compare the parameters staccato sends with the Google Analytics documentation.

```ruby
require 'staccato/adapter/logger'

tracker = Staccato.tracker('UA-XXXX-Y') do |c|
  c.adapter = Staccato::Adapter::Logger.new(Staccato.ga_collection_uri, Logger.new(STDOUT), lambda {|params| JSON.dump(params)})
end
```

If you would prefer to log to a file (default is STDOUT), you can pass in an instance of a Logger (from Ruby's stdlib) or anything that responds to `debug`.

If you would like to format the params hash as something other than `k=v` in your logs, you can pass in anything that responds to `call` and format as a string. The default should be consumable by Splunk and other logging software.

## Image URL for Email Open Tracking ##

As per [google's docs](https://developers.google.com/analytics/devguides/collection/protocol/v1/email) an `Event` hit type (suggested) may be used to generate an image tag in an email (e.g., as sent by Rails' mailers). This is useful for tracking open stats alongside your other analytics.

Things to keep in mind from Google's suggestions:

1. Hit type should be Event
2. category should be 'email'
3. action should be 'open'
4. document path should be the type of email, e.g., 'welcome' or 'invite', etc must start with a '/' and is advised to include some scope such as '/email' to make it easier to find
5. document title should be the subject of the email
6. set the user id, if it is known; NEVER set the user's email
7. system info fields may be included if known

To create a url for a hit:

```ruby
event = tracker.build_event({
  category: 'email',
  action: 'open',
  document_path: '/email/welcome',
  document_title: 'Welcome to Our Website!'
})

# use the image url in your rails template in an image tag
image_url = Staccato.as_url(event)
```

## Contributing ##

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
