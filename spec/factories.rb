FactoryGirl.define do
  factory :section do
    sequence(:name) { |n| "Section #{n}" }
  end

  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    section
  end

  factory :link do
    sequence(:url) { |n| "http://www.url_#{n}.ru" }
    description "Description url"
    category
  end

  factory :book do
    sequence(:name) { |n| "Section #{n}" }
    description "Description book"    
    image_url 'http://static.ozone.ru/multimedia/books_covers/c200/1001969331.jpg'
    source_url 'http://www.ozon.ru/context/detail/id/5508646/'
    category
  end

  factory :post do
    sequence(:title) { |n| "Post #{n}" }
    content "post content"
    category
  end

  # factory :user do
  #   sequence(:name) { |n| "Person #{n}" } # name "Michael Hartl"
  #   sequence(:email) { |n| "person_#{n}@example.com" } # email "michael@example.com"
  #   password "foobar"
  #   password_confirmation "foobar"

  #   factory :admin do
  #     admin true
  #   end
  # end

  # factory :micropost do
  #   content "Lorem ipsum"
  #   user
  # end
end