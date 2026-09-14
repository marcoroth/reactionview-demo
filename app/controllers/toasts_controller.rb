class ToastsController < ApplicationController
  KINDS = {
    "notice" => "Your changes have been saved.",
    "alert" => "We could not reach the server.",
    "warning" => "Your trial ends in three days.",
    "info" => "A new version is available."
  }.freeze

  def show
  end

  def notify
    kind = KINDS.key?(params[:kind]) ? params[:kind] : "notice"

    flash[kind] = KINDS.fetch(kind)

    redirect_to "/toasts"
  end
end
