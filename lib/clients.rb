require 'bundler/setup'
require 'pathname'
require 'json'

$LOAD_PATH.unshift(Pathname(__dir__).join("lib"))

Clients = Module.new

require_relative 'clients/cli'
