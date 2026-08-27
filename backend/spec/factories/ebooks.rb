# frozen_string_literal: true

FactoryBot.define do
  factory :ebook do
    title { Faker::Book.title }
    author { Faker::Book.author }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    status { :active }

    after(:build) do |ebook|
      next if ebook.file.attached?

      ebook.file.attach(
        io: Rails.root.join("spec/fixtures/files/sample.pdf").open,
        filename: "sample.pdf",
        content_type: "application/pdf"
      )
    end

    trait :without_author do
      author { nil }
    end

    trait :without_description do
      description { nil }
    end

    trait :without_file do
      after(:build) do |ebook|
        ebook.file.purge if ebook.file.attached?
      end
    end

    trait :deleted do
      status { :deleted }
    end
  end
end
