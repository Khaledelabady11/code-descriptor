class AddPostRefToArticles < ActiveRecord::Migration[7.0]
  def change
    add_reference :articles, :post, null: false, foreign_key: true
  end
end
