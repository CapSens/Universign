# ESign

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pay_menthe', git: 'git@projects.capsens.eu:micro-services/pay_menthe.git'
```

## TL;DR


In `config/initializers/e_sign.rb`:

```ruby
ESign.configure do |config|
  config.endpoint = ENV['UNIVERSIGN_ENDPOINT']
  config.login    = ENV['UNIVERSIGN_LOGIN']
  config.password = ENV['UNIVERSIGN_PASSWORD']
end
```


```ruby
document = ESign::Document.new(name: 'original_contract.pdf', url: self.original_contract.url)
# document = ESign::Document.new(name: 'original_contract.pdf', content: File.open('path/to/file').read)

contributor_signer = ESign::TransactionSigner.new(
  first_name:   "Signer's first name",
  last_name:    "Signer's last name",
  phone_number: "0101010101",
  success_url:  "http://success-url.con/",
  signature:    ESign::SignatureField.new(coordinate: [20, 20], page: 1)
)

transaction = ESign::Transaction.create(
  documents: [original_contract],
  signers: [contributor_signer]
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/e_sign. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

