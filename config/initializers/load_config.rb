# APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

APP_CONFIG = YAML.load(ERB.new(File.read("#{Rails.root}/config/config.yml")).result)[Rails.env]