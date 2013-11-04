class AddRemovedBySenderAndRemovedByRecipientToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :removed_by_sender, :boolean, default: false
    add_column :messages, :removed_by_recipient, :boolean, default: false
  end
end
