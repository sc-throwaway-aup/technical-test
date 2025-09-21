module Clients
  RSpec.describe List do
    describe ".from_io" do
      it "can be loaded from a pathname" do
        pathname = fixture_path("clients.json")
        list = described_class.from_io(pathname)
        expect(list.length).to be(35)

        first_record = list.first
        expect(first_record.full_name).to eq("John Doe")
        expect(first_record.email).to eq("john.doe@gmail.com")
        expect(first_record.id).to eq(1)
      end

      it "raises an error if passed invalid input" do
        io = StringIO.new("invalid")

        expect { described_class.from_io(io) }
          .to raise_error(JSON::ParserError)
      end
    end

    it "can #search for records" do
      helly = List::Record.new(full_name: "Helly R", email: "helly@lumon.inc", id: 1)
      mark = List::Record.new(full_name: "Mark S", email: "mark@lumon.inc", id: 2)
      dylan = List::Record.new(full_name: "Dylan G", email: "dylan@lumon.inc", id: 3)

      list = described_class.new([helly, mark, dylan])

      expect(list.search(:full_name, "r")).to match_array([helly, mark])
      expect(list.search(:email, "lumon")).to match_array([helly, mark, dylan])
    end

    it "can find #duplicates" do
      helly = List::Record.new(full_name: "Helly R", email: "helly@lumon.inc", id: 1)
      mark_a = List::Record.new(full_name: "Mark S", email: "mark@lumon.inc", id: 2)
      mark_b = List::Record.new(full_name: "Mark Scout", email: "mark@lumon.inc", id: 3)

      list = described_class.new([helly, mark_a, mark_b])

      expect(list.duplicates_by(:email))
        .to eq("mark@lumon.inc" => [mark_a, mark_b])
    end

  end
end
