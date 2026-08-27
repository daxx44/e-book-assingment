# frozen_string_literal: true

class AddDescriptionAndStatusToEbooks < ActiveRecord::Migration[8.1]
  def change
    add_column :ebooks, :description, :text
    add_column :ebooks, :status, :integer, null: false, default: 0

    add_index :ebooks, :status
  end
end
