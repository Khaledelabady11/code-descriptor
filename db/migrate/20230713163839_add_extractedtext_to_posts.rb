class AddExtractedtextToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :extracted_text, :text
  end
end
