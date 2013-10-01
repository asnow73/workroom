require 'spec_helper'

describe Link do
  let(:link) { FactoryGirl.build(:link) }

  subject { link }

  it { should respond_to(:url) }
  it { should respond_to(:description) }
  it { should respond_to(:category_id) }

  it { should be_valid }

  it "when category_id is not present" do
    link.category = nil
    link.should_not be_valid
  end

  it "when description is not present" do
    link.description = ""
    link.should_not be_valid
  end

  it "when url is not present" do
    link.url = ""
    link.should_not be_valid
  end

  describe "when url is alredy taken" do
    before do
      link_with_same_url = link.dup
      link_with_same_url.save
    end

    it { should_not be_valid }
  end

  describe "when same url in another category" do
    before do
      link_with_same_name = FactoryGirl.build(:link, url: link.url)
      link_with_same_name.save
    end

    it { should be_valid }
  end  
end
