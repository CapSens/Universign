require 'active_support/core_ext/hash/indifferent_access'

require "e_sign/version"
require 'xmlrpc/client'
require 'e_sign/service/document'
require 'e_sign/service/transaction'
require 'e_sign/safeguard'
require 'e_sign/signer'
require 'e_sign/transaction'
require 'e_sign/signature_field'
require 'e_sign/signer_infos'
require 'e_sign/transaction_signer'
require 'e_sign/client'
require 'e_sign/document'
require 'e_sign/configuration'
require 'e_sign/error'

module ESign
  include Error
end
