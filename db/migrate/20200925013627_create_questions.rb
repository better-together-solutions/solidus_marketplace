class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_questions do |t|
      t.text :question_text
      t.integer :created_by_id
      t.integer :supplier_id
      t.integer :product_id
      t.boolean :published, default: false
      t.boolean :resolved, default: false
      t.timestamps
    end
  end
end
