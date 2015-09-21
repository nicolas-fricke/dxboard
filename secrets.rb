require 'yaml'

class Secrets
  class << self
    def get
      @secrets ||= YAML.load_file('secrets.yml')
    end
  end
end
