helpers = Module.new do
  def fixture_path(path)
    Pathname(__dir__).join("../fixtures", path)
  end
end

RSpec.configure { |config| config.include helpers }
