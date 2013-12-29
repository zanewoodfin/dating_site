# Handles messages/conversations between users
class MessagesController < ApplicationController
  def new
    @message = Message.new
    @recipient = User.find(params[:recipient_id]) if params[:recipient_id]
  end

  def create
    @message = current_user.sent_messages.create(message_params)
    error = @message.errors.full_messages[0] unless @message.persisted?
    respond_to do |format|
      format.html do
        redirect_to :back, flash: (error ? { error: error } : {})
      end
      format.js do
        flash.now[:error] = error if error
      end
    end
  end

  def destroy
    redirect_to :back
  end

  def mass_destroy
    Message.remove_user(current_user, params[:user_ids])
    redirect_to messages_path
  end

  def index
    @conversation_headers =
      current_user.conversation_headers.paginate(page: params[:page])
  end

  def poll # format.js
    case params[:parent_action]
    when 'show'
      new_messages = current_user.received_messages.where(
        sender_id: params[:contact_id], read: false
      )
      @new_messages = new_messages.order('created_at ASC').all
      new_messages.update_all(read: true)
    else
    end
    render 'application/poll'
  end

  def show
    contact =
      if params[:contact_id]
        User.find(params[:contact_id])
      else
        message = Message.find(params[:id])
        message.sender == current_user ? message.recipient : message.sender
      end
    populate_conversation(contact)
  end

  private

  def message_params
    params.require(:message)
      .permit(:sender_id, :recipient_username, :recipient_id, :content)
  end

  def populate_conversation(contact)
    if current_user.contacts.include? contact
      @messages = current_user.conversation(contact)
      Message.where(sender_id: contact, recipient_id: current_user)
        .update_all(read: true)
      @message = Message.new
      @recipient = User.find(contact)
    else # unauthorized
      redirect_to messages_path
    end
  end
end
