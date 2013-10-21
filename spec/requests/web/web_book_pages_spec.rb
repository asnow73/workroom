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

    it { should have_title("Web books") }
    # it { should have_selector("h2", text: "Книги") }

    it "category books" do
      Book.categories.each do |category|
        page.should have_link(category.name, href: category_books_path(category))
      end
    end

    describe "not show unpublished books" do
      let!(:published_book) { FactoryGirl.create(:book, name: "published book") }
      let!(:unpublished_book) { FactoryGirl.create(:book, name: "unpublished book", published: false) }
      before do
        visit books_path
      end

      it { should have_link("#{published_book.name}", href: published_book.source_url ) }
      it { should_not have_link("#{unpublished_book.name}", href: unpublished_book.source_url ) }
    end


    describe "pagination" do
      it { page.should have_selector('div.pagination') }

      it "should list each book" do
        Book.order('created_at DESC').paginate(page: 1).each do |book|
          # page.should have_link("#{book.name}", href: book_path(book) )
          page.should have_link("#{book.name}", href: book.source_url )

          # page.should have_content(summary_for_html_text(book.content)) TODO
          page.should have_link(book.category.name, href: category_books_path(book.category))
        end
      end
    end


  end
end