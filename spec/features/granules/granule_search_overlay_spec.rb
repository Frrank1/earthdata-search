require "spec_helper"

describe "Granule search overlay", reset: false do
  before(:all) do
    Capybara.reset_sessions!
    load_page :search, ff: 'Near Real Time'
  end

  before(:each) do
    load_page :search, q: 'MODIS/Aqua Near Real Time (NRT) Geolocation Angles'
    target_collection_result('MODIS/Aqua Near Real Time (NRT) Calibrated Radiances 5-Min L1B Swath 1km').click_link "Add collection to the current project"
    target_collection_result('MODIS/Aqua Near Real Time (NRT) Geolocation Angles Daily L2G Global 1km SIN Grid Day V005').click_link "Add collection to the current project"

    find("#view-project").click
  end

  after(:each) do
    reset_overlay
    reset_project
  end

  context "when clicking the 'Filter Granules' button" do
    before(:each) do
      first_project_collection.click_link "Show granule filters"
    end

    it "should open granule search overlay" do
      expect(page).to have_visible_granule_search
      expect(page).to have_link("Hide granule filters", count: 1)
    end

    #it "should close granule search overlay when clicking again" do
    #  first_project_collection.click_link "Hide granule filters"
    #
    #  expect(page).to_not have_visible_granule_search
    #  expect(page).to have_no_link("Hide granule filters")
    #end

    # JS: In the new design you can't click the show granule search button again to close
    # so you need to click the close icon. Adding test for this new case.

    it "should close granule search overlay when clicking close icon" do
      within("#granule-search") do
        page.click_link('close')
      end

      expect(page).to_not have_visible_granule_search
      expect(page).to have_no_link("Hide granule filters")
    end

    it "should hide the granule search overlay when returning to collection list" do
      project_overview.click_link "Back to Collection Search"

      expect(page).to_not have_visible_granule_search
    end

    it "should hide the granule search overlay when returning to the project" do
      project_overview.click_link "Back to Collection Search"
      find("#view-project").click

      expect(page).to_not have_visible_granule_search
      expect(page).to have_no_link("Hide granule filters")
    end

    it "should not show 'Filter Granules' button for collections without granules" do
      within("#project-overview") do
        expect(page).to have_xpath(".//a[@title='No granules']", count: 1)
      end
    end

  end
end
