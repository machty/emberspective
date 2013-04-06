require 'spec_helper'

describe "the front-end ember app", :type => :feature, :js => true do
  it "loads" do
    visit '/'
    #within("#session") do
      #fill_in 'Login', :with => 'user@example.com'
      #fill_in 'Password', :with => 'password'
    #end
    #click_link 'Sign in'
    page.should have_content 'Emberspective'
  end
end

