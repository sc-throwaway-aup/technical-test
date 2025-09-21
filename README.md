# ShiftCare Client CLI

## Set-up

To set up your environment, run:

    bin/setup

This script assumes you have Bash, and walks you through any missing part of your development set-up.

To run tests:

    bin/rspec

## Usage

Search for names:

    bin/clients named 'will' < PATH_TO_JSON

Display duplicates:

    bin/clients duplicates < PATH_TO_JSON

JSON is read from STDIN, so you can pipe it from another command:

    curl http://server/client.json | bin/clients named 'leo'

### Notes

Code was written by hand, not using AI assistants.

Core `Clients::List` interface works with any IO object:

```ruby
Clients::List.from_io(Pathname('clients.json'))
Clients::List.from_io(File.new('clients.json'))
Clients::List.from_io(URI.open('https://server/clients.json'))
Clients::List.from_io(network_socket)
Clients::List.from_io(STDIN)
```

Commands can be added without needing to change existing code.

On a more complex CLI project I might:

- Add support for option parsing (beyond `--help`)
- Add linting, SCI, and SAST scanning
- Package the binary in a gem
- Consider streaming the JSON if memory usage becomes a problem
- Consider supporting multiple outputs (e.g. more human readable UI)
- Consider a CLI framework or library

The next best feature I would priortise would be passing command-line arguments such as:

    bin/clients search lumon --field email --fuzzy
    bin/clients duplicates --field name

This is just a matter of passing the keyword arguments for what is already implemented in `Client::List`.
