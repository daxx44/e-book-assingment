# frozen_string_literal: true

module Api
  module V1
    class EbooksController < BaseController
      rescue_from ActiveRecord::RecordNotFound, with: :render_ebook_not_found

      before_action :set_ebook, only: %i[show download destroy]

      def index
        ebooks = Ebooks::ListService.new(sort: params[:sort]).call
        render_success(
          EbookSerializer.serialize_collection(ebooks, host: request_host),
          meta: { total: ebooks.size, sort: params[:sort].presence || "recent" }
        )
      end

      def show
        render_success(EbookSerializer.serialize(@ebook, host: request_host))
      end

      def create
        ebook = Ebooks::UploadService.new(ebook_params).call
        render_success(EbookSerializer.serialize(ebook, host: request_host), status: :created)
      end

      def search
        ebooks = Ebooks::SearchService.new(params[:q], sort: params[:sort]).call
        render_success(
          EbookSerializer.serialize_collection(ebooks, host: request_host),
          meta: { total: ebooks.size, query: params[:q].to_s, sort: params[:sort].presence || "recent" }
        )
      end

      def download
        unless @ebook.file.attached?
          return render_error(
            code: "NOT_FOUND",
            message: "File not found.",
            status: :not_found
          )
        end

        send_data @ebook.file.download,
                  filename: @ebook.file.filename.to_s,
                  type: @ebook.file.content_type,
                  disposition: "attachment"
      end

      def destroy
        Ebooks::DeleteService.new(@ebook).call
        render_success({ message: "Ebook deleted successfully." })
      end

      private

      def set_ebook
        @ebook = Ebook.active.with_attached_file.with_attached_cover.find(params[:id])
      end

      def ebook_params
        params.permit(:title, :author, :description, :file, :cover)
      end

      def request_host
        "#{request.protocol}#{request.host_with_port}"
      end

      def render_ebook_not_found
        render_error(
          code: "NOT_FOUND",
          message: "Ebook not found.",
          status: :not_found
        )
      end
    end
  end
end
