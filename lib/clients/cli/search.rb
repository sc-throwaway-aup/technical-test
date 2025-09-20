module Clients::CLI
  class Search < Command
    def start
      print_as_json client_list.search(:full_name, search_term)
    end

    def search_term
      term = argv.first
      fail(InvalidCommand, "Please specify a search term") if term.empty?
      term
    end
  end
end
