helpers = Module.new do
  # Simulates invoking the command line interface.
  #
  # @example
  # invoke_cli("subcommand --with option", stdin: Pathname("fixture.json"))
  def invoke_cli!(command = "", stdin: nil, command_name: "clients")
    capturing_stdout_and_stderr do
      Clients::CLI.start(
        argv: command.split(/\s+/),
        stdin:,
        command_name:
      )
    end
  end

  # Overwrites $stdout and $stderr for the duration of the block.
  def capturing_stdout_and_stderr
    original_stdout = $stdout
    original_stderr = $stderr
    @stdout = StringIO.new
    @stderr = StringIO.new
    $stdout = @stdout
    $stderr = @stderr

    yield
  rescue
    raise
  ensure
    $stdout = original_stdout
    $stderr = original_stderr
  end

  def cli_output
    @stdout&.string.strip
  end

  def cli_warnings
    @stderr&.string.strip
  end
end

RSpec::Matchers.define :exit_successfully do |expected|
  supports_block_expectations

  match do |actual|
      actual.call
    rescue SystemExit => error
      error.success?
  end
end

RSpec.configure { |config| config.include helpers }
