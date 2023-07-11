class MakeDescriptionNullableInPost < ActiveRecord::Migration[7.0]
  def change
    change_column :posts, :description, :text, null: true

  end
end
