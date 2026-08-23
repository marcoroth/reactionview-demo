class ChatController < ApplicationController
  include FlakyServer

  def show
    @messages = Message.order(:id)
  end

  def create
    message = Message.create(message_params.merge(author: "You", sent_at: Time.current))

    @messages = [ message ]

    respond_to do |format|
      format.slots { render :show, status: :created }
      format.html { redirect_to "/chat" }
    end
  end

  def update
    message = Message.find_by(id: params[:id])

    return head :not_found unless message

    if message_params.key?(:starred)
      message.update(message_params.slice(:starred))
    else
      message.update(message_params.slice(:body).merge(edited_at: Time.current))
    end

    @messages = [ message ]

    respond_to do |format|
      format.slots { render :show }
      format.html { redirect_to "/chat" }
    end
  end

  def destroy
    Message.find_by(id: params[:id])&.destroy

    head :no_content
  end

  private

  def message_params
    params.permit(:body, :starred)
  end
end
