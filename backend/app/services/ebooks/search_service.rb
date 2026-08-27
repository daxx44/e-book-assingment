# frozen_string_literal: true

module Ebooks
  class SearchService
    def initialize(query, sort: "recent")
      @query = query
      @sort = sort
    end

    def call
      Ebooks::Sortable.apply(Ebook.search_by(@query).with_attached_file.with_attached_cover, @sort)
    end
  end
end
