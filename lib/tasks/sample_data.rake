namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_sections
    make_categories
    make_links
    make_books
    make_posts
  end
end

def make_sections
  35.times do |n|
    name = "section_#{n+1}"
    Section.create!(name: name)
  end
  @section_links = Section.create!(name: "links")
  @section_books = Section.create!(name: "books")
  @section_posts = Section.create!(name: "posts")
end

def make_categories
  sections = Section.all(limit: 6)
  35.times do |n|
    name  = "category_#{n+1}"
    sections.each { |section| section.categories.create!(name: name) }
  end
  # section_links = Section.find_by_name("links")
  @section_links.categories.create!(name: "study")
  @section_links.categories.create!(name: "work")

  # section_books = Section.find_by_name("books")
  category_programming = @section_books.categories.create!(name: "programming")
  category_workflow = @section_books.categories.create!(name: "workflow")

  @section_posts.categories.push(category_programming)
  @section_posts.categories.push(category_workflow)
end

def make_links
  # categories = Category.all(limit: 6)
  categories = Category.where(section_id: @section_links)
  35.times do |n|
    url = "url_#{n+1}"
    description = Faker::Lorem.sentence(5)
    categories.each { |category| category.links.create!(url: url, description: description) }  
  end
end

def make_books
  # categories = Category.all(limit: 6)
  categories = Category.where(section_id: @section_books)
  35.times do |n|
    name = "name_#{n+1}"
    description = Faker::Lorem.sentence(5)
    image_url = 'http://static.ozone.ru/multimedia/books_covers/c200/1001969331.jpg'
    source_url = 'http://www.ozon.ru/context/detail/id/5508646/'
    categories.each { |category| category.books.create!(name: name, description: description, image_url: image_url, source_url: source_url) }  
  end
end

def make_posts
  # categories = Category.all(limit: 6)
  categories = Category.where(section_id: @section_posts)
  35.times do |n|
    title = "title_#{n+1}"
    content = Faker::Lorem.sentence(10)
    categories.each { |category| category.posts.create!(title: title, content: content) }  
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