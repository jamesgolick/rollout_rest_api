require "sinatra"

class RolloutRestAPI < Sinatra::Base
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

  private
    def rollout
      self.class.rollout
    end
end
