require 'delegate'

# Represents a collection of client records.
class Clients::List < SimpleDelegator
  class Record < Struct.new(:id, :email, :full_name, keyword_init: true)
    def to_json(*)
      to_h.to_json(*)
    end
  end

  # Returns records with partial, case-insensitive matches against a field.
  #
  # @example
  #   collection.search(:name, "wi") # => [ #<Record name="Will …" > ]
  def search(field, term)
    filter { |record| search_compare(record[field.to_sym], term) }
  end

  # Returns a collection from any IO-compliant object.
  #
  # @example
  #   Collection.from_io(Pathname("path/to.json"))
  #   Collection.from_io(File.new("path/to.json"))
  #   Collection.from_io(URI.open("https://server/path/to.json"))
  #   Collection.from_io($stdin)
  def self.from_io(io)
    records = JSON.parse(io.read, object_class: Record)
    new(records)
  end

  private

  def search_compare(*terms)
    haystack, needle = terms.map { |term| term.downcase }
    haystack.include?(needle)
  end
end
