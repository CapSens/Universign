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
