class CreateRepositories < ActiveRecord::Migration[6.0]
  def change
    create_table :repositories do |t|
      t.integer :user_id
    	t.string :repository_name
    	t.string :description
    	t.boolean :privacy
      t.timestamps
    end
  end
end
