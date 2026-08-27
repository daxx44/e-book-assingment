# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Ebooks", type: :request do
  let(:pdf_path) { Rails.root.join("spec/fixtures/files/sample.pdf") }
  let(:pdf_upload) { fixture_file_upload(pdf_path, "application/pdf") }
  let(:invalid_upload) { fixture_file_upload(Rails.root.join("spec/fixtures/files/invalid.txt"), "text/plain") }

  describe "POST /api/v1/ebooks" do
    it "uploads a valid PDF ebook" do
      post "/api/v1/ebooks", params: {
        title: "Clean Architecture",
        author: "Robert Martin",
        description: "A software design book.",
        file: pdf_upload
      }

      expect(response).to have_http_status(:created)
      body = json_response
      expect(body["success"]).to be(true)
      expect(body["data"]["title"]).to eq("Clean Architecture")
      expect(body["data"]["author"]).to eq("Robert Martin")
      expect(body["data"]["file_type"]).to eq("application/pdf")
      expect(body["data"]["filename"]).to eq("sample.pdf")
    end

    it "returns validation error when title is missing" do
      post "/api/v1/ebooks", params: { file: pdf_upload }

      expect(response).to have_http_status(:unprocessable_entity)
      body = json_response
      expect(body["success"]).to be(false)
      expect(body["error"]["code"]).to eq("VALIDATION_FAILED")
      expect(body["error"]["details"].pluck("field")).to include("title")
    end

    it "returns validation error when file is missing" do
      post "/api/v1/ebooks", params: { title: "Missing File Book" }

      expect(response).to have_http_status(:unprocessable_entity)
      body = json_response
      expect(body["error"]["details"].pluck("field")).to include("file")
    end

    it "returns validation error for non-PDF file" do
      post "/api/v1/ebooks", params: {
        title: "Invalid Book",
        file: invalid_upload
      }

      expect(response).to have_http_status(:unprocessable_entity)
      body = json_response
      expect(body["error"]["details"].pluck("field")).to include("file")
    end
  end

  describe "GET /api/v1/ebooks" do
    it "lists active ebooks" do
      active = create(:ebook, title: "Active Book")
      create(:ebook, :deleted, title: "Deleted Book")

      get "/api/v1/ebooks"

      expect(response).to have_http_status(:ok)
      body = json_response
      expect(body["success"]).to be(true)
      expect(body["data"].size).to eq(1)
      expect(body["data"].first["title"]).to eq("Active Book")
      expect(body["meta"]["total"]).to eq(1)
      expect(body["data"].first["id"]).to eq(active.id)
    end

    it "returns an empty list when no ebooks exist" do
      get "/api/v1/ebooks"

      expect(response).to have_http_status(:ok)
      body = json_response
      expect(body["data"]).to eq([])
      expect(body["meta"]["total"]).to eq(0)
    end

    it "sorts ebooks by title when sort=title" do
      create(:ebook, title: "Zebra Book")
      create(:ebook, title: "Alpha Book")

      get "/api/v1/ebooks", params: { sort: "title" }

      expect(response).to have_http_status(:ok)
      titles = json_response["data"].pluck("title")
      expect(titles).to eq(["Alpha Book", "Zebra Book"])
    end
  end

  describe "GET /api/v1/ebooks/:id" do
    it "returns ebook details" do
      ebook = create(:ebook, title: "Show Me")

      get "/api/v1/ebooks/#{ebook.id}"

      expect(response).to have_http_status(:ok)
      body = json_response
      expect(body["data"]["title"]).to eq("Show Me")
      expect(body["data"]["filename"]).to eq("sample.pdf")
    end

    it "returns not found for missing ebook" do
      get "/api/v1/ebooks/0"

      expect(response).to have_http_status(:not_found)
      body = json_response
      expect(body["error"]["code"]).to eq("NOT_FOUND")
      expect(body["error"]["message"]).to eq("Ebook not found.")
    end

    it "returns not found for deleted ebook" do
      ebook = create(:ebook, :deleted)

      get "/api/v1/ebooks/#{ebook.id}"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /api/v1/ebooks/search" do
    before do
      create(:ebook, title: "Rails Guides", author: "DHH").tap do |ebook|
        ebook.file.blob.update!(filename: "rails-guides.pdf")
      end
      create(:ebook, title: "Dart Basics", author: "Google").tap do |ebook|
        ebook.file.blob.update!(filename: "dart-basics.pdf")
      end
    end

    it "searches by title" do
      get "/api/v1/ebooks/search", params: { q: "rails" }

      expect(response).to have_http_status(:ok)
      body = json_response
      expect(body["data"].size).to eq(1)
      expect(body["data"].first["title"]).to eq("Rails Guides")
      expect(body["meta"]["query"]).to eq("rails")
    end

    it "searches by author" do
      get "/api/v1/ebooks/search", params: { q: "google" }

      expect(response).to have_http_status(:ok)
      expect(json_response["data"].first["title"]).to eq("Dart Basics")
    end

    it "searches by filename" do
      get "/api/v1/ebooks/search", params: { q: "dart-basics" }

      expect(response).to have_http_status(:ok)
      expect(json_response["data"].first["title"]).to eq("Dart Basics")
    end

    it "returns all active ebooks when query is blank" do
      get "/api/v1/ebooks/search", params: { q: "" }

      expect(response).to have_http_status(:ok)
      expect(json_response["data"].size).to eq(2)
    end
  end

  describe "GET /api/v1/ebooks/:id/download" do
    it "downloads the PDF file" do
      ebook = create(:ebook, title: "Downloadable")

      get "/api/v1/ebooks/#{ebook.id}/download"

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("application/pdf")
      expect(response.headers["Content-Disposition"]).to include("attachment")
      expect(response.headers["Content-Disposition"]).to include("sample.pdf")
      expect(response.body).to include("%PDF")
    end

    it "returns not found for deleted ebook" do
      ebook = create(:ebook, :deleted)

      get "/api/v1/ebooks/#{ebook.id}/download"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /api/v1/ebooks/:id" do
    it "soft deletes an ebook" do
      ebook = create(:ebook, title: "Delete Me")

      delete "/api/v1/ebooks/#{ebook.id}"

      expect(response).to have_http_status(:ok)
      body = json_response
      expect(body["success"]).to be(true)
      expect(body["data"]["message"]).to eq("Ebook deleted successfully.")
      expect(ebook.reload).to be_deleted
    end

    it "removes ebook from library list after delete" do
      ebook = create(:ebook)

      delete "/api/v1/ebooks/#{ebook.id}"
      get "/api/v1/ebooks"

      expect(json_response["data"]).to be_empty
    end

    it "returns not found for missing ebook" do
      delete "/api/v1/ebooks/0"

      expect(response).to have_http_status(:not_found)
    end
  end
end
