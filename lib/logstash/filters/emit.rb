# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# From an contained event, it emits several ones by using their attributes
class LogStash::Filters::Emit < LogStash::Filters::Base

  config_name "emit"

  # Key used to match the new event
  config :key, :validate => :string, :required => true

  # Collection of attributes used to create the new events
  config :attributes, :validate => :array, :required => true

  public
  def register
  end

  public
  def filter(event)
    return unless filter?(event)
    @attributes.each do |attr|
      clone = event.clone
      @attributes.each do |field|
        next if field == attr
        @clone.remove(field)
      end
      filter_matched(clone)
      @logger.debug("Cloned event", :clone => clone, :event => event)
      yield clone
    end
  end

end # class LogStash::Filters::Clone
