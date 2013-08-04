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

    tracker = Staccato.configure do |c|
      c.id = 'UA-XXXX-Y'                # REQUIRED, your Google Analytics Tracking ID
      c.client_id = UUID.new.generate   # OPTIONAL, defaults to random UUID, can be set on each hit directly
      c.hostname = 'mysite.com'        # OPTIONAL, your hostname
    end

    # Track a Pageview
    tracker.pageview(path: '/page-path')

    # Track an Event
    tracker.event(category: '', action: '', label: '', value: 1)

## Google Documentation

https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
https://developers.google.com/analytics/devguides/collection/protocol/v1/devguide

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
