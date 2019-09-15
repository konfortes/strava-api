# REDIS_CONFIG = YAML.load(File.open( Rails.root.join("config/redis.yml") ) ).deep_symbolize_keys

$redis = Redis.new(
  url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0')
  # host: ENV.fetch('REDIS_HOST', 'localhost'),
  # port: ENV.fetch('REDIS_PORT', 6379),
  # db: ENV.fetch('REDIS_DB', 0)
)
