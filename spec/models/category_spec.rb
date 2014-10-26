require 'spec_helper'

describe Category do
  # let!(:section) { FactoryGirl.create(:section) }
  # before { @category = section.categories.build(name: "Example category") }

  let!(:category) { FactoryGirl.build(:category) }
  subject { category }

  it { should respond_to(:name) }
  it { should respond_to(:links) }
  it { should respond_to(:posts) }
  it { should respond_to(:section) }
  it { should be_valid }

  describe "when name is not present" do
    before { category.name = "" }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { category.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when name is alredy taken" do
    before do
      category_with_same_name = category.dup
      category_with_same_name.save
    end

    it { should_not be_valid }
  end

  describe "when same name in another category" do
    before do
      category_with_same_name = FactoryGirl.build(:category, name: category.name)
      category_with_same_name.save
    end

    it { should be_valid }
  end

  describe "category association" do
    before { category.save }

    describe "with link" do
      let!(:older_link) { FactoryGirl.create(:link, category: category, created_at: 1.day.ago) }
      let!(:newer_link) { FactoryGirl.create(:link, category: category, created_at: 1.hour.ago) }

      it "should destroy associated links" do
        links = category.links.to_a
        category.destroy
        links.should_not be_empty
        links.each do |link|
          Link.find_by_id(link.id).should be_nil
        end
      end
    end

    describe "with post" do
      let!(:post) { FactoryGirl.create(:post, category: category) }
      it "should destroy associated posts" do
        posts = category.posts.to_a
        category.destroy
        posts.should_not be_empty
        posts.each do |post|
          Post.find_by_id(post.id).should be_nil
        end
      end
    end

  end
end
