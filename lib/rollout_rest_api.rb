require "sinatra"

class RolloutRestAPI < Sinatra::Base
  class FakeUser < Struct.new(:id); end

  class << self
    attr_accessor :rollout
  end

  get "/:feature.json" do
    Yajl::Encoder.encode(rollout.info(params[:feature]))
  end

  put "/:feature/groups" do
    rollout.activate_group(params[:feature], params[:group])
    "ok"
  end

  delete "/:feature/groups" do
    rollout.deactivate_group(params[:feature], params[:group])
    "ok"
  end

  put "/:feature/users" do
    rollout.activate_user(params[:feature], FakeUser.new(params[:user]))
    "ok"
  end

  delete "/:feature/users" do
    rollout.deactivate_user(params[:feature], FakeUser.new(params[:user]))
    "ok"
  end

  private
    def rollout
      self.class.rollout
    end
end
