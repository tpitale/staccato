# Staccato

Ruby Google Analytics Measurement

## Installation

Add this line to your application's Gemfile:

    gem 'staccato'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install staccato

## Usage

    tracker = Staccato.tracker('UA-XXXX-Y') # REQUIRED, your Google Analytics Tracking ID

`#tracker` optionally takes a second param for the `client_id` value
By default, the `client_id` is set to a random UUID with `SecureRandom.uuid`

    # Track a Pageview (all values optional)
    tracker.pageview(path: '/page-path', hostname: 'mysite.com', title: 'A Page!')

    # Track an Event (all values optional)
    tracker.event(category: 'video', action: 'play', label: 'cars', value: 1)

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
