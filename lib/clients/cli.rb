module Clients::CLI
  module_function

  def start(**)
    Command.start(**)
  end

  def commands
    Command.subclasses
  end
end

require_relative 'cli/command'
Pathname(__dir__).glob('cli/**/*.rb') { |file| require file }
