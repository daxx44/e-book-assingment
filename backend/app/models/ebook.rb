# frozen_string_literal: true

# Ebook represents metadata for a single PDF title in the digital library.
#
# Purpose:
#   Persist queryable ebook attributes (title, author, description, lifecycle status)
#   while delegating binary PDF storage to Active Storage.
#
# Responsibilities:
#   - Associations (has_one_attached :file)
#   - Enums (status: active, deleted)
#   - Validations (metadata + attached PDF rules)
#   - Scopes (recent, alphabetical, active, search_by)
#
# Validation strategy:
#   Model enforces data integrity. Upload orchestration and request handling belong
#   in services/controllers (Phase 3).
#
# Future scalability:
#   - status supports soft delete without losing audit history
#   - Optional user_id, categories, or bookmarks can be added via new columns/tables
#   - File metadata (size, type, filename) stays on active_storage_blobs
#
class Ebook < ApplicationRecord
  has_one_attached :file
  has_one_attached :cover

  MAX_FILE_SIZE = 100.megabytes
  MAX_COVER_SIZE = 10.megabytes
  ALLOWED_CONTENT_TYPES = %w[application/pdf application/epub+zip].freeze
  ALLOWED_COVER_TYPES = %w[image/jpeg image/png image/webp].freeze

  enum :status, { active: 0, deleted: 1 }, default: :active

  normalizes :title, with: ->(value) { value.to_s.strip.presence }
  normalizes :author, with: ->(value) { value.presence }
  normalizes :description, with: ->(value) { value.presence }

  validates :title, presence: true, length: { maximum: 255 }
  validates :author, length: { maximum: 255 }, allow_nil: true
  validates :description, length: { maximum: 5000 }, allow_nil: true
  validates :status, presence: true
  validate :validate_file_attachment
  validate :validate_cover_attachment

  scope :recent, -> { order(created_at: :desc) }
  scope :alphabetical, -> { order(:title) }
  scope :active, -> { where(status: :active) }
  scope :search_by, lambda { |query|
    normalized_query = query.to_s.strip
    relation = active.left_joins(file_attachment: :blob)
    next relation if normalized_query.blank?

    term = "%#{sanitize_sql_like(normalized_query)}%"
    relation.where(
      "ebooks.title ILIKE :term OR ebooks.author ILIKE :term OR active_storage_blobs.filename ILIKE :term",
      term: term
    ).distinct
  }

  private

  def validate_file_attachment
    unless file.attached?
      errors.add(:file, :blank)
      return
    end

    unless ALLOWED_CONTENT_TYPES.include?(file.content_type)
      errors.add(:file, :invalid_type, message: "must be a PDF or EPUB")
    end

    if file.byte_size <= 0
      errors.add(:file, :blank)
    elsif file.byte_size > MAX_FILE_SIZE
      errors.add(:file, :too_large, message: "must be less than 100 MB")
    end
  end

  def validate_cover_attachment
    return unless cover.attached?

    unless ALLOWED_COVER_TYPES.include?(cover.content_type)
      errors.add(:cover, :invalid_type, message: "must be a JPEG, PNG, or WebP image")
    end

    if cover.byte_size > MAX_COVER_SIZE
      errors.add(:cover, :too_large, message: "must be less than 10 MB")
    end
  end
end
