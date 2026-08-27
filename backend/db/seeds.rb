# frozen_string_literal: true

# Demo ebooks for local development. Run: rails db:seed
# Uses the same sample PDF as the test suite.

return if Rails.env.test?

sample_pdf = Rails.root.join("spec/fixtures/files/sample.pdf")
unless File.exist?(sample_pdf)
  puts "Seed skipped: #{sample_pdf} not found."
  return
end

demo_books = [
  { title: "Clean Architecture", author: "Robert C. Martin", description: "A Craftsman's Guide to Software Structure and Design." },
  { title: "The Pragmatic Programmer", author: "David Thomas", description: "Your journey to mastery." },
  { title: "Design Patterns", author: "Gang of Four", description: "Elements of reusable object-oriented software." }
]

demo_books.each do |attrs|
  ebook = Ebook.find_or_initialize_by(title: attrs[:title])
  next if ebook.persisted? && ebook.file.attached?

  ebook.assign_attributes(
    author: attrs[:author],
    description: attrs[:description],
    status: :active
  )
  ebook.save!
  ebook.file.attach(
    io: File.open(sample_pdf),
    filename: "#{attrs[:title].parameterize}.pdf",
    content_type: "application/pdf"
  )
  puts "Seeded: #{ebook.title}"
end
