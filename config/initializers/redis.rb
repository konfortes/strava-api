REDIS_CONFIG = YAML.load(File.open( Rails.root.join("config/redis.yml") ) ).deep_symbolize_keys
$redis = Redis.new(REDIS_CONFIG[Rails.env.to_sym])
