require "io/wait"

module Clients
  class CLI::Command
    InvalidCommand = Class.new(StandardError)

    attr_reader :argv, :stdin, :command_name

    def initialize(argv: ARGV, stdin: $stdin, command_name: $0)
      @argv = argv
      @stdin = stdin
      @command_name = command_name
    end

    def start
      if requested_subcommand.nil? || requested_subcommand == "--help"
        puts usage
        exit
      end

      subcommand.start(argv:, stdin:)
    rescue InvalidCommand => error
      warn error.message
      abort usage
    end

    def usage
      "Usage: #{command_name} {#{subcommand_names.join(",")}} [options] < JSON"
    end

    def self.command_name
      self.name.split('::').last.downcase
    end

    def self.start(**)
      new(**).start
    end

    def self.subcommands
      subclasses
    end

    private

    def subcommand
       find_subcommand(name: requested_subcommand) ||
        fail(InvalidCommand, "Unknown command: #{requested_subcommand}")
    end

    def subcommands
      self.class.subcommands
    end

    def find_subcommand(name:)
      subcommands.find { |sub| sub.command_name == requested_subcommand }
    end

    def requested_subcommand
      @requested_subcommand ||= argv.shift
    end

    def subcommand_names
      subcommands.map(&:command_name)
    end

    def print_as_json(data)
      puts JSON.pretty_generate(data)
    end

    def client_list
      fail InvalidCommand, "JSON missing" if stdin.nil? || !stdin.ready?
      List.from_io(stdin)
    end
  end
end
