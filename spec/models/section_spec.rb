require 'spec_helper'

describe Section do
  let!(:section) { FactoryGirl.build(:section) }
  subject { section }

  it { should respond_to(:name) }
  it { should respond_to(:categories) }
  it { should be_valid }

  describe "when name is not present" do
    before { section.name = "" }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { section.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when name is alredy taken" do
    before do
      section_with_same_name = section.dup
      section_with_same_name.save
    end

    it { should_not be_valid }
  end

  describe "section associations" do
    before { section.save }
    let!(:older_category) { FactoryGirl.create(:category, section: section, created_at: 1.day.ago) }
    let!(:newer_category) { FactoryGirl.create(:category, section: section, created_at: 1.hour.ago) }

    it "should destroy associated categories" do
      categories = section.categories.to_a
      section.destroy
      categories.should_not be_empty
      categories.each do |category|
        Category.find_by_id(category.id).should be_nil
      end
    end
  end

end
