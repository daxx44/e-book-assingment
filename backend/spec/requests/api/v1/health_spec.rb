# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Health", type: :request do
  describe "GET /api/v1/health" do
    it "returns a successful health check response" do
      get "/api/v1/health"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["success"]).to be(true)
      expect(body["data"]["status"]).to eq("ok")
      expect(body["data"]["service"]).to eq("ebook-library-api")
    end
  end
end
