require 'spec_helper'
# require 'application_helper'
# include ApplicationHelper

def prepare_data
  section_links = FactoryGirl.create(:section, name: "links")
  category_1 = FactoryGirl.create(:category, section: section_links)
  category_2 = FactoryGirl.create(:category, section: section_links)

  12.times do
    FactoryGirl.create(:link, category: category_1)
    FactoryGirl.create(:link, category: category_2)
  end
end

def clear_data
  Section.delete_all
  Category.delete_all
  Link.delete_all
end

describe "Web link" do
  subject { page }

  describe "Index links" do
    before(:all) { prepare_data }
    after(:all) { clear_data }

    before do
      visit links_path
    end

    it { should have_title("Web links") }

    describe "group links" do
      it "should have all categories title and links" do
        Link.groups_links(10).each do |category, links|
          page.should have_selector('h2', text: category.name)
          links.each do |link|
            page.should have_link("", href: link.url)
            page.should have_content(link.description)
            page.should have_link("Все ссылки", href: "#")
          end
        end
      end
    end

  end

end