# frozen_string_literal: true

module Ebooks
  class ListService
    def initialize(sort: "recent")
      @sort = sort
    end

    def call
      Ebooks::Sortable.apply(Ebook.active.with_attached_file.with_attached_cover, @sort)
    end
  end
end
