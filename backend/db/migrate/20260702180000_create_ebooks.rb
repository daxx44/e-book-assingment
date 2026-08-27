# frozen_string_literal: true

class CreateEbooks < ActiveRecord::Migration[8.1]
  def change
    create_table :ebooks do |t|
      t.string :title, null: false
      t.string :author

      t.timestamps
    end

    add_index :ebooks, :title
    add_index :ebooks, :author
    add_index :ebooks, :created_at
  end
end
