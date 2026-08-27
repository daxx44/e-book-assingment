# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ebook, type: :model do
  describe "associations" do
    it "has one attached PDF file" do
      ebook = build(:ebook)
      expect(ebook.file).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end

  describe "enums" do
    it "defaults to active status" do
      ebook = create(:ebook)
      expect(ebook).to be_active
      expect(ebook.status).to eq("active")
    end

    it "supports deleted status" do
      ebook = create(:ebook, :deleted)
      expect(ebook).to be_deleted
    end
  end

  describe "validations" do
    subject(:ebook) { build(:ebook) }

    it { is_expected.to be_valid }

    it "requires a title" do
      ebook.title = nil
      expect(ebook).not_to be_valid
      expect(ebook.errors[:title]).to include("can't be blank")
    end

    it "strips whitespace from title" do
      ebook.title = "  Clean Architecture  "
      ebook.valid?
      expect(ebook.title).to eq("Clean Architecture")
    end

    it "allows a missing author" do
      ebook.author = nil
      expect(ebook).to be_valid
    end

    it "normalizes blank author to nil" do
      ebook.author = "   "
      ebook.valid?
      expect(ebook.author).to be_nil
    end

    it "allows a missing description" do
      ebook.description = nil
      expect(ebook).to be_valid
    end

    it "normalizes blank description to nil" do
      ebook.description = "   "
      ebook.valid?
      expect(ebook.description).to be_nil
    end

    it "requires an attached PDF file" do
      ebook = build(:ebook, :without_file)
      expect(ebook).not_to be_valid
      expect(ebook.errors[:file]).to include("can't be blank")
    end

    it "rejects non-PDF files" do
      ebook = build(:ebook, :without_file)
      ebook.file.attach(
        io: Rails.root.join("spec/fixtures/files/invalid.txt").open,
        filename: "invalid.txt",
        content_type: "text/plain"
      )

      expect(ebook).not_to be_valid
      expect(ebook.errors[:file]).to be_present
    end

    it "rejects files larger than 100 MB" do
      ebook = build(:ebook)
      blob = ebook.file.blob
      allow(blob).to receive(:byte_size).and_return(101.megabytes)

      expect(ebook).not_to be_valid
      expect(ebook.errors[:file]).to be_present
    end
  end

  describe "scopes" do
    describe ".active" do
      it "returns only active ebooks" do
        active_book = create(:ebook, title: "Active Book")
        deleted_book = create(:ebook, :deleted, title: "Deleted Book")

        expect(described_class.active).to contain_exactly(active_book)
        expect(described_class.active).not_to include(deleted_book)
      end
    end

    describe ".recent" do
      it "orders ebooks by newest first" do
        older = create(:ebook, title: "Older Book", created_at: 2.days.ago)
        newer = create(:ebook, title: "Newer Book", created_at: 1.day.ago)

        expect(described_class.recent).to eq([ newer, older ])
      end
    end

    describe ".alphabetical" do
      it "orders ebooks by title" do
        zebra = create(:ebook, title: "Zebra Tales")
        alpha = create(:ebook, title: "Alpha Guide")

        expect(described_class.alphabetical).to eq([ alpha, zebra ])
      end
    end

    describe ".search_by" do
      let!(:rails_book) do
        create(:ebook, title: "Rails Patterns", author: "David Heinemeier Hansson").tap do |ebook|
          ebook.file.blob.update!(filename: "rails-patterns.pdf")
        end
      end

      let!(:flutter_book) do
        create(:ebook, title: "Flutter UI", author: "Google Team").tap do |ebook|
          ebook.file.blob.update!(filename: "flutter-ui.pdf")
        end
      end

      let!(:deleted_book) do
        create(:ebook, :deleted, title: "Deleted Rails Guide").tap do |ebook|
          ebook.file.blob.update!(filename: "deleted-rails.pdf")
        end
      end

      it "returns active ebooks when query is blank" do
        expect(described_class.search_by("")).to contain_exactly(rails_book, flutter_book)
      end

      it "searches by title" do
        expect(described_class.search_by("rails")).to contain_exactly(rails_book)
      end

      it "searches by author" do
        expect(described_class.search_by("google")).to contain_exactly(flutter_book)
      end

      it "searches by filename via active storage blob" do
        expect(described_class.search_by("flutter-ui")).to contain_exactly(flutter_book)
      end

      it "is case insensitive" do
        expect(described_class.search_by("RAILS")).to contain_exactly(rails_book)
      end

      it "excludes deleted ebooks" do
        expect(described_class.search_by("deleted")).to be_empty
      end
    end
  end
end
