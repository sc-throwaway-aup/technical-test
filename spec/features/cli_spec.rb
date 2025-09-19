RSpec.describe 'CLI' do
  it 'prints usage if invoked without arguments' do
    expect { invoke_cli! }.to exit_successfully
    expect(cli_output).to start_with("Usage: clients")
    expect(cli_output).to end_with("< JSON")
  end

  it 'prints usage if invoked with --help' do
    expect { invoke_cli!("--help") }.to exit_successfully
    expect(cli_output).to match(/usage/i)
  end

  it 'warns and shows usage if an invalid subcommand is given' do
    expect { invoke_cli!("unknown") }.not_to exit_successfully
    expect(cli_warnings).to include(/unknown command: unknown/i)
    expect(cli_warnings).to match(/usage/i)
  end
end
