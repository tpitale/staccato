## Staccato 0.5.3 ##

*   Adapter bugfix in tracker

    *@olerichter00*

## Staccato 0.5.2 ##

*   Multiple adapter support

    *Tony Pitale - @tpitale*

## Staccato 0.5.1 ##

*   Logger adapter uses the appropriate `::Logger` class

    *Tony Pitale - @tpitale*

## Staccato 0.5.0 ##

*   SSL option set on tracker is used when generating `as_url` from a hit

    *Tony Pitale - @tpitale*

## Staccato 0.4.7 ##

*   Set ssl option when creating a tracker

    *Tony Pitale - @tpitale*

## Staccato 0.4.6 ##

*   Fix for Faraday constant in adapter

    *Tony Pitale - @tpitale*

## Staccato 0.4.5 ##

*   Add adapter writer to noop tracker

    *Alexey Kirimov - @poshe*

*   Add hit_defaults to noop tracker

    *Tony Pitale - @tpitale*

## Staccato 0.4.4 ##

*   Adds `Staccato.as_url` to generate a url from a hit, useful for image urls in emails to track opens into GA

    *Tony Pitale - @tpitale*

## Staccato 0.4.3 ##

*   Adds `data_source` as global option

    *Matt Thomson - @matt-thomson*

## Staccato 0.4.2 ##

*   Logger adapter for development

    *Tony Pitale - @tpitale*

## Staccato 0.4.1 ##

*   Screenview hit type

    *Tony Pitale - @tpitale*

## Staccato 0.4.0 ##

*   UDP Adapter for use with Staccato::Proxy

    *Tony Pitale - @tpitale*

## Staccato 0.3.1 ##

*   Add customer dimensions and metrics to Product and ProductImpression measurements

    *Agustin Cavilliotti - @cavi21*

## Staccato 0.3.0 ##

*   HTTP Adapters for HTTP, net/http, and Faraday

    *Tony Pitale - @tpitale*

## Staccato 0.2.1 ##

*   Fix product impression prefix

    *Ricky Hanna - @rickyhanna*

## Staccato 0.2.0 ##

*   Enhanced Ecommerce Measurements
*   Measurable module for further extension of hits
*   New global hit options for ecommerce

    *Tony Pitale - @tpitale*

## Staccato 0.1.1 ##

*   fixes NoopTracker when track! is called on a hit *martin1keogh*

## Staccato 0.1.0 ##

*   adds support for all global hit options in any hit type
*   adds default hit options at the tracker level
*   adds proper handling of boolean values into 1/0
*   have travis-ci run 2.0, 2.1 rubies

    *Tony Pitale*

*   adds user_ip/user_agent *@medullan*

## Staccato 0.0.4 ##

*   adds session start/end controls
*   adds custom dimensions and metrics

    *Tony Pitale*

## Staccato 0.0.3 ##

*   adds YARD documentation
*   adds context experiment global options
*   adds language and encoding global options
*   adds referrer global option

    *Tony Pitale*

## Staccato 0.0.2 ##

*   adds timing tracking with block timing
*   adds ecommerce tracking
*   adds non-interactive tracking option
*   automate building a random client id with SecureRandom.uuid
*   adds no-op tracking for unconfigured and testing environments
*   adds travis CI
*   adds coverage metric
*   adds code climate

    *Tony Pitale*

## Staccato 0.0.1 ##

*   Initial implementation
*   Track a pageview
*   Track an event

    *Tony Pitale*
