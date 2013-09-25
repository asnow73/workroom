require 'spec_helper'

describe Link do
  let(:category) { FactoryGirl.create(:category) }
  before { @link = category.links.build(url: "www.mail.ru", description: "mail", category_id: category.id) }

  subject { @link }

  it { should respond_to(:url) }
  it { should respond_to(:description) }
  it { should respond_to(:category_id) }

  it { should be_valid }

  it "when category_id is not present" do
    link = Link.new(url: "www.mail.ru", description: "mail", category_id: nil)
    link.should_not be_valid
  end

  it "when description is not present" do
    link = Link.new(url: "www.mail.ru", description: "", category_id: category.id)
    link.should_not be_valid
  end

  it "when url is not present" do
    link = Link.new(url: "", description: "mail", category_id: category.id)
    link.should_not be_valid
  end

  describe "when url is alredy taken" do
    before do
      link_with_same_url = @link.dup
      link_with_same_url.save
    end

    it { should_not be_valid }
  end
end
