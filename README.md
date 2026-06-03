# RubyUniversign

RubyUniversign is a Ruby gem for interacting with the [Universign](https://www.universign.com/) electronic signature API.

It eases requests to the Universign API: uploading documents, requesting signatures and following their state.

This gem is **not** officially made by Universign, but was originally created by [CapSens](https://capsens.eu/) for internal usage.

It currently integrates the electronic signature service only, not the other Universign services (timestamping and server stamp).

## Requirements

- Ruby `>= 3.0`
- An Universign account (login / password / endpoint)

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
  config.endpoint = 'your_universign_endpoint' # Required ...
  config.login    = 'your_login' # Required ...
  config.password = 'your_password' # Required ...
  config.proxy    = 'your_proxy_uri:your_proxy_port' # Optionnal ...
  config.timeout  = 30 # Optionnal if you wanna change the default XMLRPC Timeout ...
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
  first_name:      "Signer's first name",
  last_name:       "Signer's last name",
  email:           'test@gmail.com',
  phone_number:    '0101010101',
  success_url:     'https://google.com/',
  signature_field: Universign::SignatureField.new(coordinate: [20, 20], page: 1)
)

transaction = Universign::Transaction.create(
  documents: [document_from_url, document_from_content],
  signers:   [signer],
  options:   { profile: 'default', final_doc_sent: true }
)

transaction.sign_url
# => "https://sign.test.universign.eu/fr/signature/?id=f052e35e-a792-4440-bb67-6b5c3f17aa30"

transaction.signer_id
# => "f052e35e-a792-4440-bb67-6b5c3f17aa30"

transaction.transaction_id
# => "9696179e-a43d-4803-beeb-9e5c02fd159b"

# reload transaction data from universign:
transaction = Universign::Transaction.new('9696179e-a43d-4803-beeb-9e5c02fd159b')
# was the transaction signed by the user ?
transaction.signed?
```

When you rebuild a transaction from its id with `Universign::Transaction.new(id)`,
the transaction info is fetched **lazily**: no API call is made until you read an
attribute that needs it (`status`, `signed?`, `signers`, `documents`, …). Reading
several attributes only triggers a single `getTransactionInfo` call, which is then
memoized.

```ruby
transaction = Universign::Transaction.new('9696179e-...')

transaction.status        # => "completed"
transaction.signed?       # => true
transaction.signers       # => [#<Universign::SignerInfos>, ...]
transaction.signers.first.status # => "signed"
transaction.documents     # => [#<Universign::Document>, ...] (signed PDFs)
```

The gem also supports the updated way of creating multiple fields per document:

- Multiple signatures
  ```ruby
  doc_1 = Universign::Document.new(
    name:    'one.pdf',
    content: File.open('spec/fixtures/universign-guide-8.8.pdf').read,
    signature_fields: [
      Universign::SignatureField.new(coordinate: [20, 20], page: 1, signer_index: 0),
      Universign::SignatureField.new(coordinate: [80, 20], page: 1, signer_index: 0)
    ]
  )

  doc_2 = Universign::Document.new(
    name:    'two.pdf',
    content: File.open('spec/fixtures/universign-guide-8.8.pdf').read,
    signature_fields: [
      Universign::SignatureField.new(coordinate: [100, 120], page: 4, signer_index: 0),
    ]
  )

  transaction = Universign::Transaction.create(
    documents: [doc_1, doc_2],
    signers:   [signer],
    options:   { profile: 'default', final_doc_sent: true }
  )
  ```

- Multiple checkboxes
  ```ruby
  Universign::Document.new(
    name:    "one.pdf",
    content: File.open("spec/fixtures/universign-guide-8.8.pdf").read,
    check_box_texts: [
      "My first checkbox text",
      "My second checkbox text",
      ""
    ]
  )
  ```
  Note that the last checkbox must be an empty string as requested in the official documentation.

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
* `sign_url` is where you must redirect your users for them to sign (always a String, available without any extra API call right after `.create`)
* `signer_id` is the signer id parsed from the sign URL
* `transaction_id` is the id you must save to retrieve it later. You can request up-to-date informations from Universign with `Universign::Transaction.new(transaction_id)`.
* `signers` returns the signers progression as `Universign::SignerInfos` beans
* `signed?` returns a boolean that tells you if the transaction is signed, or not !

## Error handling

Every error raised by the gem inherits from `Universign::Error`, so you can rescue
them all at once or handle them individually:

```ruby
begin
  Universign::Transaction.create(documents: documents, signers: signers)
rescue Universign::NotEnoughTokens
  # your Universign account ran out of tokens
rescue Universign::DocumentURLInvalid => e
  # Universign could not download a document by URL
  e.url # => the offending URL
rescue Universign::Error => e
  # any other Universign error
end
```

The most common ones are:

| Exception                                | Raised when                                            |
|------------------------------------------|--------------------------------------------------------|
| `Universign::InvalidCredentials`         | login / password / endpoint are wrong                  |
| `Universign::NotEnoughTokens`            | the account has no signature token left                |
| `Universign::DocumentURLInvalid`         | a document URL cannot be downloaded (`#url` exposes it) |
| `Universign::UnknownDocument`            | the transaction or custom id is unknown                |
| `Universign::DocumentNotSigned`          | the document is not signed yet                          |
| `Universign::ErrorWhenSigningPDF`        | Universign failed to sign the PDF                       |
| `Universign::UnknownOption`              | an unknown option was passed to `.create`              |
| `Universign::InvalidSignatureField`      | a signature field is not a `Universign::SignatureField`|

## Universign documentation

As of September 25th 2018, all official Universign documentation can be found at https://help.universign.com/hc/fr/sections/360000148149-Guides-Universign.

## Upgrading from 1.x to 2.0

2.0 is a breaking release. The highlights:

- `Transaction#url` is removed. Use `Transaction#sign_url` (always a String) and
  `Transaction#signer_id` instead.
- `Transaction.new(id)` no longer hits the API in the constructor — the info is
  loaded lazily on first access.
- `TransactionSigner#birtdate=` is renamed to `#birthdate=`.
- Internal `raise "string"` calls are now typed `Universign::Error` subclasses.
- Minimum Ruby version is now `3.0`.

See the [CHANGELOG](CHANGELOG.md) for the full list.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` (or `bundle exec rake spec`) to run the tests. The suite hits no network — the XML-RPC client is stubbed — and enforces 100% line and branch coverage via SimpleCov (report in `coverage/`). You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CapSens/universign. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
