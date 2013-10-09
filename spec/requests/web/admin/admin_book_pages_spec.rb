require 'spec_helper'

describe "Admin book" do
  subject { page }

  describe "index" do
    before do
      visit admin_books_path
    end

    it { should have_title('Admin book') }
    it { should have_selector('h1', text: 'Администрирование книг') }
    it { should have_link('Новая книга...', href: new_admin_book_path) }

    describe "pagination" do
      before(:all) do
        32.times { FactoryGirl.create(:book) }
      end
      after(:all) do
        Book.delete_all
        Category.delete_all
        Section.delete_all
      end

      it { should have_selector('div.pagination') }

      it "should list each book" do
        Book.order('created_at DESC').paginate(page: 1).each do |book|
          page.should have_selector('td', text: book.name)
          page.should have_link('', href: edit_admin_book_path(book))
          page.should have_link('', href: admin_book_path(book))
        end
      end
    end
  end

  describe "deleting book" do
    let!(:book_for_delete) { FactoryGirl.create(:book) }
    before do
      visit admin_books_path
    end

    it "should delete book" do
      expect { click_link('', href: admin_book_path(book_for_delete)) }.to change(Book, :count).by(-1)
      page.should have_selector('div.alert.alert-success')
    end
  end 

  describe "edit" do
    let!(:section_books) { FactoryGirl.create(:section, name: "books") }
    let!(:category_books) { FactoryGirl.create(:category, section: section_books) }
    let!(:book) { FactoryGirl.create(:book, category: category_books) }

    let!(:another_category) { FactoryGirl.create(:category) }

    before do
      visit edit_admin_book_path(book)
    end

    it { should have_title('Admin book update') }
    it { should have_selector('h1', text: 'Обновление книги') }
    it { should have_button('Сохранить изменения') }
    it { find_field('book_category_id').value.should eq book.category.id.to_s }
    it { should_not have_selector('option', text: another_category.name) }

    describe "with invalid information" do
      describe "without name" do
        before do
          fill_in "Название", with: ''
          click_button "Сохранить изменения"
        end
        it { should have_content('error') }
      end

      describe "without description" do
        before do
          fill_in "Описание", with: ''
          click_button "Сохранить изменения"
        end
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      let(:new_name)  { "new name" }
      before do
        fill_in "Название", with: new_name
        click_button "Сохранить изменения"
      end
      it { should have_selector('div.alert.alert-success') }
      specify { book.reload.name.should == new_name }
    end
  end

  describe "create" do
    let!(:section_books) { FactoryGirl.create(:section, name: "books") }
    let!(:category_books) { FactoryGirl.create(:category, section: section_books) }

    let!(:another_category) { FactoryGirl.create(:category) }

    before do
      visit new_admin_book_path
    end

    it { should have_title('Admin book create') }
    it { should have_selector('h1', text: 'Создание новой книги') }
    it { should have_button('Создать книгу') }
    it { find_field('book_category_id').value.should eq category_books.id.to_s }
    it { should_not have_selector('option', text: another_category.name) }

    describe "with invalid information" do
      before do
        fill_in "Название", with: ''
        expect { click_button "Создать книгу" }.not_to change(Book, :count)
      end
      it { should have_content('error') }
    end

    describe "with valid information" do
      before do
        fill_in "Название", with: "new name"
        fill_in "Описание", with: "desc"
        select category_books.name, :from => "Категория"
        expect { click_button "Создать книгу" }.to change(Book, :count).by(1)
      end
      it { should have_selector('div.alert.alert-success') }      
    end
  end

end