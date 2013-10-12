require 'spec_helper'

describe "Static pages" do
  subject { page }

  describe "Home page" do
    before { visit root_path }
    # it "should have the content 'WorkRoom'" do
    #   expect(page).to have_content('WorkRoom')
    # end

    # it "should have the title 'Home'" do
    #   expect(page).to have_title('Home')
    # end

    it { should have_content('WorkRoom') }
    it { should have_title('Home') }

    it { should have_link('Ссылки', links_path) }
    it { should have_link('Заметки', posts_path) }
  end
end