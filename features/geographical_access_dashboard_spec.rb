require 'spec_helper'

feature 'Geographical Access Dashboard' do
  scenario 'A user can view a map of access to the application' do
    visit '/dashboards/geographical'

    expect(page).to have_content 'Geographical Access Patterns'
    expect(page).to have_css('.gm-style')
  end

end