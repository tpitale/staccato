# Staccato

Ruby library to track into the official Google Analytics Measurement Protocol

https://developers.google.com/analytics/devguides/collection/protocol/v1/

**NOTE:** The Measurement Protocol is part of Universal Analytics, which is currently available in public beta. Data from the measurement protocol will only be processed in Universal Analytics enabled properties.

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
 :experiment_variant]
```

Boolean options like `anonymize_ip` will be converted from `true`/`false` into `1`/`0` as per the tracking API docs.

#### Custom Dimensions and Metrics ####

```ruby
hit = Staccato::Pageview.new(tracker, '/sports-page-5')
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

## Tracker Hit Defaults ##

Global parameters can be set as defaults on the tracker, and will be used for all hits (unless overwritten by parameters set directly on a hit).

The following example creates a tracker with a default hostname. The two pageviews will track the default hostname and the page path passed in.

```ruby
tracker = Staccato.tracker('UA-XXXX-Y', client_id, {document_hostname: 'example.com'})

tracker.pageview(path: '/videos/123')
tracker.pageview(path: '/videos/987')
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
