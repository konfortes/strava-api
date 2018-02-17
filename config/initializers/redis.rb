# REDIS_CONFIG = YAML.load(File.open( Rails.root.join("config/redis.yml") ) ).deep_symbolize_keys
$redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], db: ENV['REDIS_DB'])
