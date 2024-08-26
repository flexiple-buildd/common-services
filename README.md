# Common Services

This Repo contains common services which can be used accorss flexiple projects

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'common_services', '~> 0.1.0', github: 'flexiple-buildd/common-services'
```

And then execute

```bash
bundle install
```

Add api keys

```
BEEHIIV_API_KEY: ''
BEEHIIV_BUILDD_PUBLICATION_ID: ''
```

## How to Use

Require using

```ruby
require 'common_services/beehiiv_service'
```

Use beehiiv service by passing subscriber and source

```ruby
response = BeehiivService.create_subscription(@subscriber, source: 'signup')
```
