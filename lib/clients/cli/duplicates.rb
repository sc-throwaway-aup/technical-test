module Clients::CLI
  class Duplicates < Command
    def start
      print_as_json client_list.duplicates_by(:email)
    end
  end
end
