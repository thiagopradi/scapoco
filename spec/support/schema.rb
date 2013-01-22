ActiveRecord::Schema.define do
  self.verbose = false

  create_table :posts, :force => true do |t|
    t.string :text, null: false
    t.string :title, null: false
    t.integer :flag, null: false
    t.timestamps
  end
end
