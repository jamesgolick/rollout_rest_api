require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "redis"
require "rollout"
require "yajl"

describe "RolloutRestApi" do
  def app
    RolloutRestAPI
  end

  before do
    @redis = Redis.new
    @redis.flushdb
    @rollout = Rollout.new(@redis)
    RolloutRestAPI.rollout = @rollout
  end

  it "gets /:feature.json" do
    get "/chat.json"

    last_response.should be_ok
    last_response.body.should == Yajl::Encoder.encode(@rollout.info(:chat))
  end

  it "adds a group" do
    put "/chat/groups", :group => "caretakers"
    last_response.should be_ok
    @rollout.info(:chat)[:groups].should include(:caretakers)
  end

  it "removes a group" do
    @rollout.activate_group(:chat, :caretakers)
    @rollout.activate_group(:chat, :greeters)

    delete "/chat/groups", :group => "caretakers"
    last_response.should be_ok
    @rollout.info(:chat)[:groups].should == [:greeters]
  end
end
