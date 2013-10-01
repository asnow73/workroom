namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    # make_users
    # make_microposts
    make_sections
    make_categories
    make_links
  end
end

def make_sections
  35.times do |n|
    name = "section_#{n+1}"
    Section.create!(name: name)
  end
  Section.create!(name: "links")
  Section.create!(name: "books")
end

def make_categories
  sections = Section.all(limit: 6)
  35.times do |n|
    name  = "category_#{n+1}"
    # Category.create!(name: name)
    sections.each { |section| section.categories.create!(name: name) }
  end
  section_links = Section.find_by_name("links")
  section_links.categories.create!(name: "study")
  section_links.categories.create!(name: "work")
end

def make_links
  categories = Category.all(limit: 6)
  35.times do |n|
    url = "url_#{n+1}"
    description = Faker::Lorem.sentence(5)
    categories.each { |category| category.links.create!(url: url, description: description) }  
  end
end

# def make_users
#   admin = User.create!(name: "Example User", email: "example@railstutorial.org", password: "foobar", password_confirmation: "foobar")
#   admin.toggle!(:admin)
#   99.times do |n|
#     name  = Faker::Name.name
#     email = "example-#{n+1}@railstutorial.org"
#     password  = "password"
#     User.create!(name: name, email: email, password: password, password_confirmation: password)
#   end
# end

# def make_microposts
#   users = User.all(limit: 6)
#   50.times do
#     content = Faker::Lorem.sentence(5)
#     users.each { |user| user.microposts.create!(content: content) }
#   end
# end

# def make_relationships
#   users = User.all
#   user = users.first
#   followed_users = users[2..50]
#   followers = users[3..40]
#   followed_users.each { |followed| user.follow!(followed) }
#   followers.each { |follower| follower.follow!(user) }
# end