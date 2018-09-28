# Prometheus Metrics for Ruby and a Pushgateway

Prometheus is available as a ruby gem for making metrics available on a
`/metrics` endpoint, but if you need a pushgateway as the middle man, there is
more required configuration that isn't easily available. This gem sets
everything up as required, allowing you to increment metrics without worrying
about the fuss of configuring a non-standard use

## Getting started

This section will get you up and running with a basic setup for this project.
For live deployment, see the section below

### Configuration

This gem takes a configuration block to set it up to your requirements.

```ruby
PushgatewayMetrics.configure do |config|
  config.gateway = <hostname_of_gateway>
  config.instance_name = <instance_name>
end
```

`<hostname_of_gateway>` requires the protocol and port as well as the hostname,
like `http://pushgateway.local:9091/`
`<instance_name>` is what will appear on your metrics as the 'source' of data

## Running the tests

## Deployment

Require `pushgateway-metrics` gem 

## Built with

## Contributing

## Versioning

We use [SemVer](semver.org) versioning. For the versions available, see the tags on this repository

## Authors

- Ollie Nye - Initial version, maintanence, testing - [Github](https://github.com/ollie-nye)

## License

This project is licensed under the MIT license, see LICENSE.md for details.

## Acknowledgements

- [Jim Myhrberg](https://github.com/jimeh) For code styling and conciseness tips
