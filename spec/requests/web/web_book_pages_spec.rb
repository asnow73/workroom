require 'spec_helper'

describe "Web book" do
  def prepare_data
    section = FactoryGirl.create(:section, name: "books")
    @category_1 = FactoryGirl.create(:category, section: section)
    @category_2 = FactoryGirl.create(:category, section: section)

    36.times do
      FactoryGirl.create(:book, category: @category_1)
      FactoryGirl.create(:book, category: @category_2)
    end
  end

  def clear_data
    Section.delete_all
    Category.delete_all
    Book.delete_all
  end

  before(:all) { prepare_data }
  after(:all) { clear_data }

  subject { page }

  describe "Index books" do
    before do
      visit books_path
    end

    # it { should have_title("Web books") }
    # it { should have_selector("h2", text: "Книги") }

    it "category books" do
      Book.categories.each do |category|
        should have_link(category.name, href: category_books_path(category))
      end
    end

    describe "not show unpublished books" do
      let!(:published_book) { FactoryGirl.create(:book, name: "published book") }
      let!(:unpublished_book) { FactoryGirl.create(:book, name: "unpublished book", published: false) }
      before do
        visit books_path
      end

      it { should have_link("#{published_book.name}", href: book_path(published_book) ) }
      it { should_not have_link("#{unpublished_book.name}", href: book_path(unpublished_book) ) }
    end


    describe "pagination" do
      it { should have_selector('div.pagination') }

      it "should list each book" do
        Book.order('created_at DESC').paginate(page: 1).each do |book|
          should have_link("#{book.name}", href: book_path(book) )
          # should have_content(summary_for_html_text(book.content)) TODO
          should have_link(book.category.name, href: category_books_path(book.category))
        end
      end
    end
  end

  describe "Show book" do
    let!(:book) { FactoryGirl.create(:book) }
    before do
      visit book_path(book)
    end

    it { should have_title("Web book") }
    it { should have_selector("div", text: book.name) }
    it { should have_content(book.description) }
    it { should have_link("#{book.category.name}", href: books_path(books: {category_id: book.category} )) }
    it { should have_link("Можно купить тут", href: book.source_url) }

    let!(:unpublished_book) { FactoryGirl.create(:book, published: false) }
    it "unpublished book for user" do
      expect {
        visit book_path(unpublished_book)
      }.to raise_error
    end

    let!(:user_admin) { FactoryGirl.create(:user) }
    it "unpublished book for admin" do
      sign_in(user_admin)
      visit book_path(unpublished_book)
      
      should have_title("Web book")
      should have_selector("div", text: unpublished_book.name)
      should have_content(unpublished_book.description)
      should have_link("#{unpublished_book.category.name}", href: books_path(books: {category_id: unpublished_book.category} ))
      should have_link("Можно купить тут", href: unpublished_book.source_url)
    end

  end  
end