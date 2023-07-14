class RemoveDescriptionFromPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :description
  end
end
