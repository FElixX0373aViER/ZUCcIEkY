# 代码生成时间: 2025-10-10 03:29:20
# FirewallManager class to handle firewall rules
class FirewallManager
  attr_accessor :rules

  # Initialize the firewall manager with an empty set of rules
  def initialize
    @rules = []
  end

  # Add a new rule to the firewall
  def add_rule(rule)
    @rules << rule
  end

  # Remove a rule from the firewall
  def remove_rule(rule)
    @rules.delete(rule)
  end

  # Get all firewall rules
  def get_rules
    @rules
  end
end

# Initialize the firewall manager
manager = FirewallManager.new

# Sinatra application for managing firewall rules
get '/' do
  "Welcome to the Firewall Manager"
end

# Route to display all firewall rules
get '/rules' do
  rules = manager.get_rules
  if rules.empty?
    "No rules found."
  else
    rules.to_json
  end
end

# Route to add a new firewall rule
post '/add_rule' do
  begin
    rule = JSON.parse(request.body.read)
    manager.add_rule(rule)
    "Rule added successfully."
  rescue JSON::ParserError
    'Invalid JSON format.'
  end
end

# Route to remove a firewall rule
delete '/remove_rule' do
  begin
    rule = JSON.parse(request.body.read)
    manager.remove_rule(rule)
    "Rule removed successfully."
  rescue JSON::ParserError
    'Invalid JSON format.'
  end
end