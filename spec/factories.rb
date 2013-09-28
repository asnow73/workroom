FactoryGirl.define do
  factory :section do
    sequence(:name) { |n| "Section #{n}" }
  end

  factory :category do
    sequence(:name) { |n| "Category #{n}" }
  end

  factory :link do
    sequence(:url) { |n| "url #{n}" }
    description "Description url"
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