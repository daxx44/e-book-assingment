# frozen_string_literal: true

module Api
  module V1
    class EbookSerializer
      class << self
        def serialize(ebook, host: nil)
          blob = ebook.file.blob

          {
            id: ebook.id,
            title: ebook.title,
            author: ebook.author,
            description: ebook.description,
            status: ebook.status,
            file_type: blob&.content_type,
            file_size: blob&.byte_size,
            filename: blob&.filename&.to_s,
            cover_url: cover_url_for(ebook, host: host),
            created_at: ebook.created_at.iso8601,
            updated_at: ebook.updated_at.iso8601
          }
        end

        def serialize_collection(ebooks, host: nil)
          ebooks.map { |ebook| serialize(ebook, host: host) }
        end

        private

        def cover_url_for(ebook, host: nil)
          return nil unless ebook.cover.attached?

          Rails.application.routes.url_helpers.rails_blob_url(
            ebook.cover,
            host: host || resolve_host
          )
        end

        def resolve_host
          ENV.fetch("APP_HOST", "localhost:3000")
        end
      end
    end
  end
end
