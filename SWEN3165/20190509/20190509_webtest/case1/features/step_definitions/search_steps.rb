require 'selenium-webdriver'
driver = Selenium::WebDriver.for :firefox

Given(/^We navigate to the homepage$/) do
  driver.navigate.to "http://mock.agiletrailblazers.com/"
end

When(/^We search for the word agile$/) do
  driver.find_element(:id, 's').send_keys("agile")
  driver.find_element(:id, 'submit-button').click
end

Then(/^The results for the search will be displayed$/) do
  wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
  begin
    element = wait.until { driver.find_element(:id => "search-title") }
    expect(element.text).to eq('Search Results for: agile')
  ensure
    driver.quit
  end
end

Then /^I pause for a while$/ do
  sleep 10
end

