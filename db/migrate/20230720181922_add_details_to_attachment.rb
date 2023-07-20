class AddDetailsToAttachment < ActiveRecord::Migration[7.0]
  def change
    add_column :attachments, :width, :string
    add_column :attachments, :height, :string
  end
end
