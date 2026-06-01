v2.0.0
-------------------------
- **BREAKING**: remove `Transaction#url` (its return type was inconsistent — a
  String after `.create`, an Array after `getTransactionInfo`). Use the new
  `Transaction#sign_url` (always a String) and `Transaction#signer_id` instead.
- **BREAKING**: rename `TransactionSigner#birtdate=` to `#birthdate=` (typo fix).
- **BREAKING**: raise required Ruby version to `>= 3.0`.
- **BREAKING**: every internal `raise "string"` now raises a typed
  `Universign::Error` subclass (`UnknownOption`, `InvalidSignatureField`,
  `SignatureFieldsMustBeAnArray`, `CheckBoxTextsMustBeAnArray`) instead of a
  bare `RuntimeError`.
- Implement `Transaction#signers`, returning the signers progression as
  `Universign::SignerInfos` beans (previously raised `NotImplementedYet`).
- Fix `Signer#first_name`/`#last_name` readers, which were looking up keys the
  setters never wrote.
- Make `Document.from_data`/`Signer.from_data` thread-safe (no more shared
  class-level state).
- Simplify `Safeguard`: drop the unused callback mechanism, name the `73020`
  fault code, and match by fault code before falling back to fault strings.
- Internal cleanup: `params` is now the single source of truth for documents
  and signers, `.travis.yml` removed, `frozen_string_literal` enabled.
- `Transaction` no longer fetches the transaction info eagerly in the
  constructor: `getTransactionInfo` is now performed lazily on first access to
  `data` (or any attribute relying on it). `.create` therefore no longer makes
  a redundant second API call, and `sign_url`/`signer_id` are available without
  any extra request.
- Test suite no longer depends on VCR/WebMock/dotenv: the XML-RPC client is
  stubbed directly.
- Document the ability to send a document by URL (`Universign::Document.new(url:)`)
  so Universign downloads it itself, instead of uploading base64 content.

v1.6.0
-------------------------
- Added the possibility to add required checkboxes to `Universign::Document`.

v1.5.1
-------------------------
- Fix bugs on multi-threads requests.

v1.5.0
-------------------------
- Add `xmlrpc` as dependency, and raise required ruby version to 2.3.

v1.4.0
-------------------------
- Refactor and rename errors. They now all inherit from `Universign::Error`.

v1.3.1
-------------------------

- Fixing regressions added

v1.3.0 - NOT WORKING
-------------------------

- Adding the possibility to configure proxy and timeout options for the XMLRPC Client

v1.2.1
-------------------------

- Bumping rake development dependancy due to security issues

v1.2.0
-------------------------

- Add `chaining_mode` to `Universign::Transaction` options.

v1.1.1
-------------------------

- bugfix : do not add `name` parameter to SignatureField when it's nil.

v1.1.0
-------------------------

- SignatureField can be managed with a named field instead of coordinates.

v1.0.0
-------------------------

- rename gem to `ruby_universign`
- rename`ESign` module to `Universign`
- release gem on rubygems

v0.1.6 (26/11/2015)
-------------------------

- Add `final_doc_sent` and `final_doc_requester_sent` parameters to `ESign::Service::Transaction`
