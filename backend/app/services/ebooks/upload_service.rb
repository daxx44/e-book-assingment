# frozen_string_literal: true

module Ebooks
  class UploadService
    def initialize(params)
      @params = params
    end

    def call
      validate_file_param!

      ebook = Ebook.new(
        title: @params[:title],
        author: @params[:author],
        description: @params[:description]
      )
      ebook.file.attach(@params[:file])
      ebook.cover.attach(@params[:cover]) if @params[:cover].present?
      ebook.save!
      ebook
    end

    private

    def validate_file_param!
      return if @params[:file].present?

      ebook = Ebook.new(title: @params[:title])
      ebook.errors.add(:file, :blank)
      raise ActiveRecord::RecordInvalid, ebook
    end
  end
end
