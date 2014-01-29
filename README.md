# Staccato

Ruby Google Analytics Measurement

[![Gem Version](https://badge.fury.io/rb/staccato.png)](http://badge.fury.io/rb/staccato)
[![Build Status](https://travis-ci.org/tpitale/staccato.png?branch=master)](https://travis-ci.org/tpitale/staccato)
[![Code Climate](https://codeclimate.com/github/tpitale/staccato.png)](https://codeclimate.com/github/tpitale/staccato)

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

`#tracker` optionally takes a second param for the `client_id` value
By default, the `client_id` is set to a random UUID with `SecureRandom.uuid`

### Track some data ###

```ruby
# Track a Pageview (all values optional)
tracker.pageview(path: '/page-path', hostname: 'mysite.com', title: 'A Page!').track!

# Track an Event (all values optional)
tracker.event(category: 'video', action: 'play', label: 'cars', value: 1).track!

# Track social activity (all values REQUIRED)
tracker.social(action: 'like', network: 'facebook', target: '/something').track!

# Track exceptions (all values optional)
tracker.exception(description: 'RuntimeException', fatal: true).track!

# Track timing (all values optional, but should include time)
tracker.timing(category: 'runtime', variable: 'db', label: 'query', time: 50).track! # time in milliseconds

t = tracker.timing(category: 'runtime', variable: 'db', label: 'query') do
  some_code_here
end
t.track!

# Track transaction (transaction_id REQUIRED)
tracker.transaction({
  transaction_id: 12345,
  affiliation: 'clothing',
  revenue: 17.98,
  shipping: 2.00,
  tax: 2.50,
  currency: 'EUR'
}).track!

# Track transaction item (matching transaction_id and item name REQUIRED)
tracker.transaction_item({
  transaction_id: 12345,
  name: 'Shirt',
  price: 8.99,
  quantity: 2,
  code: 'afhcka1230',
  variation: 'red',
  currency: 'EUR'
}).track!
```

Each one of these methods returns a particular `hit` type. To send the tracking information to google analytics, simply call `track!`.

```ruby
tracker.pageview(path: '/item-120291').track!
```

### "Global" Options ###

#### Custom Dimensions and Metrics ####

```ruby
hit = tracker.pageview('/sports-page-5')
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

Other options are acceptable to start and end a session: `session_start`, `sessoin_end`, and `stop_session`.

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

## Google Documentation

https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide
https://developers.google.com/analytics/devguides/collection/protocol/v1/reference
https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
