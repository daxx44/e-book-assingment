# frozen_string_literal: true

module Ebooks
  class DeleteService
    def initialize(ebook)
      @ebook = ebook
    end

    def call
      @ebook.update!(status: :deleted)
      @ebook
    end
  end
end
