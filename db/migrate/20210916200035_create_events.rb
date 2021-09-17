class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.integer :repository_id
    	t.string :event_type
      t.timestamps
    end
  end
end
