class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_answers do |t|
      t.text :answer_text
      t.integer :question_id
      t.integer :user_id
      t.timestamps
    end
  end
end
