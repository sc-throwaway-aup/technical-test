RSpec.describe Clients::CLI do
  it 'can .start the CLI' do
    options = {
      argv: %i[ a b ],
      stdin: 'c',
      command_name: 'clients'
    }

    expect(::Clients::CLI::Command).to receive(:start)
      .with(**options)
      .and_return(:delegated)

    expect(described_class.start(**options)).to be(:delegated)
  end

  it 'returns available .commands' do
    expect(described_class.commands).to eq(Clients::CLI::Command.subclasses)
  end
end
