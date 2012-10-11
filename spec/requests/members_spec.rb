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
    #pending "We don't sell widets yet."
    visit "http://members.oreilly.com/widgets"

    page.should have_content("Buy a Widget") # Fails.  We don't sell those.
  end
end

describe "RX homepage" do
  describe "Speaker Cheeseboard" do
    it "should show four speakers" do
      using_wait_time 10 do # Ok if this loads slower / last on page
        visit "http://strataconf.com/rx2012"
        within ".cheese-board" do
          should_load_four_speakers
          page.all(".speaker img", :visible => true).size.should == 4
        end
      end
    end

    it "should show new speakers when the right arrow is clicked" do
      using_wait_time 10 do # Ok if this loads slower / last on page
        visit "http://strataconf.com/rx2012"
        within ".cheese-board" do
          should_load_four_speakers

          initial_speakers = Hash.new
          page.all(".speaker .caption", :visible => true).each do |capt|
            initial_speakers[capt.text] = true
            Rails.logger.debug "before: "+capt.text
          end

          find(".control-right").click
          should_load_four_speakers

          page.all(".speaker .caption", :visible => true).each do |capt|
            Rails.logger.debug "after: "+capt.text
            initial_speakers.should_not have_key(capt.text)
          end
        end
      end
    end

    # This makes Capybara wait till it can find exactly four.
    # Otherwise, it won't know how long to wait for JavaScript to
    # insert/remove elements before searching for them.
    def should_load_four_speakers
      page.should have_css(([".speaker"] * 4).join(" + "))
      page.should have_no_css(([".speaker"] * 5).join(" + "))
    end

  end
end
