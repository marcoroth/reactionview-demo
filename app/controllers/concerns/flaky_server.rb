module FlakyServer
  extend ActiveSupport::Concern

  DELAY = 0.8
  MAX_DELAY = 5.0

  included do
    before_action :refuse_or_stall, only: %i[create update destroy]
  end

  class_methods do
    attr_accessor :refusing
  end

  def refuse
    self.class.refusing = !self.class.refusing

    render json: { refusing: self.class.refusing }
  end

  private

  def refuse_or_stall
    return head :service_unavailable if self.class.refusing

    sleep params.fetch(:delay, DELAY).to_f.clamp(0, MAX_DELAY)
  end
end
