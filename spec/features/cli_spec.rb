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

  context "search subcommand" do
    it "complains if input is not given" do
      expect { invoke_cli!("search leo") }.not_to exit_successfully
      expect(cli_warnings).to include(/json missing/i)
      expect(cli_warnings).to match(/usage/i)
    end

    it "can find partial matches by name" do
      ada = { id: 1, full_name: "Ada", email: "ada@example.com" }
      leo = { id: 2, full_name: "Leo", email: "leo@example.com" }
      theo = { id: 3, full_name: "Theo", email: "theo@example.com" }

      stdin = stdin_as_json_from([ada, leo, theo])

      invoke_cli!("search eo", stdin:)

      expect(parsed_json_cli_output).to match_array([leo, theo])
    end
  end
end
