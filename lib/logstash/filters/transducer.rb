# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# It splits a given event properties into several new ones where basically
# a set of attributes are used as a single value. This filter is useful when 
# you have a data format
class LogStash::Filters::Transducer < LogStash::Filters::Base

  config_name "transducer"

  # Field name used to store the emited attribute
  config :field, :validate => :string, :default => "target"

  # Collection of attributes used to create the new events
  config :attributes, :validate => :array, :required => true

  def register; end;

  def filter(event)
    return unless filter?(event)
    @attributes.each do |attr|
      clone = event.clone
      clone[@field]  = attr
      clone["value"] = clone[attr]
      @attributes.each do |field|
        clone.remove(field)
      end
      filter_matched(clone)
      @logger.debug("Generated event", :clone => clone, :event => event)
      yield clone
    end
    event.cancel
  end
end
