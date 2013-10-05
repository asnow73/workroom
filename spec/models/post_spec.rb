require 'spec_helper'

describe Post do
  let(:post) { FactoryGirl.build(:post) }

  subject { post }

  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:category) }

  it { should be_valid }

  it "when title is not present" do
    post.title = ""
    should_not be_valid
  end

  it "when content is not present" do
    post.content = ""
    should_not be_valid
  end

  it "when category is not present" do
    post.category = nil
    should_not be_valid
  end

  describe "when title is alredy teken" do
    before do
      post_with_same_title = post.dup
      post_with_same_title.save
    end

    it { should_not be_valid }
  end

  describe "when same title in another category" do
    before do
      post_with_same_title = FactoryGirl.build(:post, title: post.title)
      post_with_same_title.save
    end

    it { should be_valid }
  end  

end
