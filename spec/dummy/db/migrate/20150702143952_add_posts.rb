class AddPosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string    :title
      t.text      :body
      t.timestamp :publish_time
      t.integer   :creator_id
      t.integer   :updator_id
      t.timestamps
    end
  end
end
