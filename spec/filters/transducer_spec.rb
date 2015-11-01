# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/filters/transducer"


describe LogStash::Filters::Transducer do

  let(:config) do
    { "attributes" => ["a", "b", "c"] }
  end

  it "should register" do
    plugin = LogStash::Plugin.lookup("filter", "transducer").new(config)
    expect {plugin.register}.to_not raise_error
  end

  describe "#event creation" do

    let(:attrs) { { "year" => 2015, "type" => "rain", "gen" => 1, "feb" => 2, "marz" => 3 } }
    let(:_event) { LogStash::Event.new(attrs) }

    let(:config) do
      {  "attributes" => ["gen", "feb", "marz"] }
    end

    subject(:plugin) { LogStash::Filters::Transducer.new(config) }

    let(:events) do
      events = []
      plugin.filter(_event) do |generated|
        events << generated
      end
      events
    end

    it "generate a new event per attribute" do
      expect(events.count).to eq(3)
    end

    context "#format events" do

      let(:event) { events.first.to_hash }

      it "have a proper target" do
        expect(event["target"]).to eq("gen")
      end

      it "have a proper value" do
        expect(event["value"]).to eq(1)
      end

      it "have the proper attributes" do
        expect(event.keys).not_to include("feb")
      end

    end

  end

end
