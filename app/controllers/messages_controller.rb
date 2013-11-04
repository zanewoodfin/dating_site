class MessagesController < ApplicationController

  def new
    @message = Message.new
    @recipient = User.find(params[:recipient_id]) if params[:recipient_id]
  end

  def create
    @message = current_user.sent_messages.build(message_params)
    @valid = @message.save
    redirect_to @message
  end

  def destroy
    redirect_to :back
  end

  def index
    @contacts = current_user.contacts
  end

  def show
    contact = if params[:contact_id]
      params[:contact_id]
    else
      message = Message.find(params[:id])
      message.sender == current_user ? message.recipient : message.sender
    end
    set = [contact, current_user]
    @messages = Message.where(sender_id: set, recipient_id: set).order('created_at ASC')
  end

private

  def message_params
    params.require(:message).permit(:sender_id, :recipient_username, :recipient_id, :content)
  end

end
