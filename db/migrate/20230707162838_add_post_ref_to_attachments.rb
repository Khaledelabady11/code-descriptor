class AddPostRefToAttachments < ActiveRecord::Migration[7.0]
  def change
    add_reference :attachments, :post, null: false, foreign_key: true
  end
end
