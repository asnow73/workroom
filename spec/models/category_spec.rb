require 'spec_helper'

describe Category do
  before { @category = Category.new(name: "Example category") }
  subject { @category }

  it { should respond_to(:name) }
  it { should respond_to(:links) }
  it { should be_valid }

  describe "when name is not present" do
    before { @category.name = "" }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @category.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when name is alredy taken" do
    before do
      category_with_same_name = @category.dup
      category_with_same_name.save
    end

    it { should_not be_valid }
  end

  describe "category associations" do
    before { @category.save }
    let!(:older_link) { FactoryGirl.create(:link, category: @category, created_at: 1.day.ago) }
    let!(:newer_link) { FactoryGirl.create(:link, category: @category, created_at: 1.hour.ago) }

    it "should destroy associated links" do
      links = @category.links.to_a
      @category.destroy
      links.should_not be_empty
      links.each do |link|
        Link.find_by_id(link.id).should be_nil
      end
    end
  end
end
