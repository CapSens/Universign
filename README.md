# RubyUniversign

RubyUniversign is a Ruby gem for interacting with [Universign](https://www.universign.com/) electronic signature API.

It ease requests to Universign API, documents uploads and following signature state.

This gem is **not** officialy made by Universign, but was originally created by [CapSens](https://capsens.eu/) for internal usage.

This gem currently integrate electronic signature service, but not other Universign services (timestamping and server stamp).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_universign', require: 'universign'
```

And then `bundle`

Or install it with:

```
gem install ruby_universign
```

And load it with:

```ruby
require 'universign'
```


## Usage

Configuration:

```ruby
# if you're using Rails, put this in an initializer
Universign.configure do |config|
  config.endpoint = ENV['UNIVERSIGN_ENDPOINT']
  config.login    = ENV['UNIVERSIGN_LOGIN']
  config.password = ENV['UNIVERSIGN_PASSWORD']
end
```

Then, you can create a transaction like this:

```ruby
document_from_url = Universign::Document.new(
  name: 'my_contract.pdf',
  url:  'http://www.orimi.com/pdf-test.pdf'
)
document_from_content = Universign::Document.new(
  name:    'another.pdf',
  content: File.open('spec/fixtures/universign-guide-8.8.pdf').read
)

signer = Universign::TransactionSigner.new(
  first_name:   "Signer's first name",
  last_name:    "Signer's last name",
  email:        'test@gmail.com',
  phone_number: '0101010101',
  success_url:  'https://google.com/',
  signature:    Universign::SignatureField.new(coordinate: [20, 20], page: 1)
)

transaction = Universign::Transaction.create(
  documents: [document_from_url, document_from_content],
  signers:   [signer],
  options:   { profile: 'default', final_doc_sent: true }
)

transaction.url
# => "https://sign.test.universign.eu/fr/signature/?id=f052e35e-a792-4440-bb67-6b5c3f17aa30"

transaction.transaction_id
# => "9696179e-a43d-4803-beeb-9e5c02fd159b"

# reload transaction data from universign:
transaction = Universign::Transaction.new('9696179e-a43d-4803-beeb-9e5c02fd159b')
# was the transaction signed by the user ?
transaction.signed?
```

### `Universign::Document`

It can be created with either your file's content or your file's url.

### `Universign::SignatureField`

Nothing much to say here. It follows Universign's signature field.

You can pass the coordinates of the signature or the name of the field.

If the PDF already contains a named signature field, you can use this parameter instead of giving the coordinates (which will be ignored). If the name of this field does not exist in the document, the given coordinates will be used instead.

### `Universign::TransactionSigner`

* `success_url` is where your user will be redirected after signing the documents.
* `phone_number` is optional. If you don't specify it, Universign will ask the user for it at the time of the signature.
* `email` is optional, unless you want to use transaction's `final_doc_sent` option (to send signed documents to user's email).

### `Universign::Transaction`

To start a transaction with Universign, you only require documents and signers.

Options are, as the name imply, optional ! Available options are (snake_case of Universign's names):

```
custom_id
description
handwritten_signature_mode
certificate_type
language
identification_type
handwritten_signature
profile
final_doc_sent
final_doc_requester_sent
chaining_mode
```

Default options are:
```ruby
{
  handwrittenSignatureMode: 1,
  identificationType:       'sms',
  language:                 'fr',
  certificateType:          'simple'
}
```

For more informations on theses options, see Universign's official documentation

Once your transaction is created:
* `url` is where you must redirect your users for them to sign
* `transaction_id` is the id you must save to retrieve it later. You can request up-to-date informations from Universign with `Universign::Transaction.new(transaction_id)`.
* `signed?` returns a boolean that tells you if the transaction is signed, or not !

## Universign documentation

As of September 25th 2018, all official Universign documentation can be found at https://help.universign.com/hc/fr/sections/360000148149-Guides-Universign.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CapSens/universign. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
