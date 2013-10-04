require 'spec_helper'

describe Book do
  let(:book) { FactoryGirl.build(:book) }

  subject { book }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:image_url) }
  it { should respond_to(:source_url) } 
  it { should respond_to(:category) }

  it { should be_valid }

  it "when name is not present" do
    book.name = ""
    should_not be_valid
  end

  it "when description is not present" do
    book.description = ""
    should_not be_valid
  end

  it "when category is not present" do
    book.category = nil
    should_not be_valid
  end

  describe "when name is alredy taken" do
    before do
      book_with_same_name = book.dup
      book_with_same_name.save
    end

    it { should_not be_valid }
  end

  describe "when same name in another category" do
    before do
      book_with_same_name = FactoryGirl.build(:book, name: book.name)
      book_with_same_name.save
    end

    it { should be_valid }
  end  

end
