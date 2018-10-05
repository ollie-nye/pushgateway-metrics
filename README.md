# Prometheus Metrics for Ruby and a Pushgateway

Prometheus is available as a ruby gem for making metrics available on a
`/metrics` endpoint, but if you need a pushgateway as the middle man, there is
more required configuration that is difficult to find elsewhere. This gem sets
everything up as required, allowing you to increment metrics without worrying
about the fuss of configuring a non-standard use

Available on RubyGems at https://rubygems.org/gems/pushgateway-metrics

## Getting started

Require `pushgateway_metrics` gem

Configure the gem using the configuration block above. Be sure not to include a
trailing slash on the end of the hostname

### Configuration

This gem takes a configuration block to set it up to your requirements.

```ruby
PushgatewayMetrics.configure do |config|
  config.gateway = <hostname_of_gateway>
  config.instance_name = <instance_name>
  config.job = <job_name>
end
```

`<hostname_of_gateway>` requires the protocol and port as well as the hostname,
like `http://pushgateway.local:9091`. Do not include a trailing slash
`<instance_name>` is what will appear on your metrics as the instance of the job
`<job_name>` is what will appear on your metrics as the job or source

### Helper method

```ruby
def metrics
  PushgatewayMetrics::Metrics.instance
end
```

This makes the gem available as a `metrics` method, keeping lines short and
readable

### Normal usage

After configuring the gem, metrics are created and incremented in the same
place. Call `incr` on the `metrics` method defined above with the following
parameters:

- `:metric_name` - Symbol - Name of the metric. Appears in the pushgateway
  first
- Options hash as below:

Key                       | Type           | Default Value | Description
------------------------- | -------------- | ------------- | ---
`type: :{counter\|gauge}` | Symbol         | `:counter`    | Type of the metric
`value: <number>`         | Number literal | 1             | Amount to increase the metric by
`labels: <hash>`          | Hash           | `{}`          | Labels to add to the metric

When all metrics have been set, call `push` on `metrics`. This will push all
recorded metrics to the gateway.

```ruby
# Absolute basic, will increment a counter called 'requests' by 1 with no labels
metrics.incr(:requests)

# All options in use
metrics.incr(:free_memory, type: :gauge, value: 1024, labels: { app: 'ruby' })
metrics.push
```

## Example project (sinatra)

See `/example`

Run the project with `start.sh`, it will spin up a pushgateway in docker, then
return its `/metrics` endpoint as the response to any requests served by the
example.

The example runs on localhost, port 4567. Visiting this will show the output of
the pushgateway, and a metric added by this gem under `metric_name{instance...`

## Running the tests

Run `rspec` in the root of the project

## Versioning

We use [SemVer](semver.org) versioning. For the versions available, see the tags
on this repository

## Authors

- Ollie Nye - Initial version, maintanence, testing -
  [GitHub](https://github.com/ollie-nye)

## License

This project is licensed under the MIT license, see LICENSE.md for details.

## Acknowledgements

- [Jim Myhrberg](https://github.com/jimeh) For code styling and conciseness tips
