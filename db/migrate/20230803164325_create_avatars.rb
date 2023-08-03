class CreateAvatars < ActiveRecord::Migration[7.0]
  def change
    create_table :avatars do |t|
      t.string :resource_id
      t.string :resource_type
      t.string :resource_url
      t.text :raw_response
      t.string :width
      t.string :height
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
