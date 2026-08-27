# frozen_string_literal: true

module Ebooks
  module Sortable
    SORT_OPTIONS = {
      "recent" => ->(relation) { relation.recent },
      "title" => ->(relation) { relation.alphabetical },
      "author" => ->(relation) { relation.order(Arel.sql("LOWER(COALESCE(author, ''))")) }
    }.freeze

    module_function

    def apply(relation, sort)
      sorter = SORT_OPTIONS.fetch(sort.to_s, SORT_OPTIONS["recent"])
      sorter.call(relation)
    end
  end
end
