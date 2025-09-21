module Clients::CLI
  class Search < Command
    def start
      print_as_json client_list.search(:full_name, search_term)
    end

    def search_term
      term = argv.first

      if term.nil? || term.empty?
        fail(InvalidCommand, "Please specify a search term")
      end

      term
    end
  end
end
