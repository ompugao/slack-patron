require 'mongo'

config = YAML.load_file('./config.yml')

db_config = config['database']
logger = Logger.new($stdout)
logger.level = Logger::WARN
db = Mongo::Client.new([ db_config['uri'] ], database: db_config['database'], logger: logger)

Users = db['users']
Users.indexes.create_one({ :id => 1 }, :unique => true)
def replace_users(users)
  unless users.nil?
    ids = users.map{ |user| user['id'] }
    Users.find(id: { '$in' => ids }).delete_many
    Users.insert_many(users)
  end
end

Channels = db['channels']
Channels.indexes.create_one({ :id => 1 }, :unique => true)
def replace_channels(channels)
  unless channels.nil?
    ids = channels.map{ |channel| channel['id'] }
    Channels.find(id: { '$in' => ids }).delete_many
    Channels.insert_many(channels)
  end
end

Ims = db['ims']
Ims.indexes.create_one({ :id => 1 }, :unique => true)
def replace_ims(ims)
  unless ims.nil?
    ids = ims.map{ |im| im['id'] }
    Ims.find(id: { '$in' => ids }).delete_many
    Ims.insert_many(ims)
  end
end

Messages = db['messages']
Messages.indexes.create_one({ :ts => 1 }, :unique => true)
def insert_message(message)
  # Message can be duplicate but dont check (to improve the speed)
  begin
    Messages.insert_one(message)
  rescue
  end
end
