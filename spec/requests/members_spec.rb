require 'spec_helper'

describe "SSO" do
  it "should login a user from Conferences site" do
    visit "http://strataconf.com/stratany2012/user/account"

    within "#std_login" do
      # For some reason Selenium doens't think this label is associated
      # with the field...
      #fill_in "Email Address:", :with => "marcel+20121011@oreilly.com"
      fill_in "email", :with => "marcel+20121011@oreilly.com"
      fill_in "password", :with => "marcel20121011"
      click_button "Sign In"
    end

    page.should have_content("Your Strata Conference + Hadoop World summary")
  end

  it "should sell widgets" do
    visit "http://members.oreilly.com/widgets"

    page.should have_content("Buy a Widget") # Fails.  We don't sell those.
  end
end
