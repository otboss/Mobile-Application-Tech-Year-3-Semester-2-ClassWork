require 'selenium-webdriver'

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "http://mock.agiletrailblazers.com/"

driver.find_element(:id, 's').send_keys("agile")
driver.find_element(:id, 'submit-button').click

wait = Selenium::WebDriver::Wait.new(:timeout => 5) # seconds
begin
  element = wait.until { driver.find_element(:id => "search-title") }
  element.text.include? 'Search Results for: agile'
ensure
  driver.quit
end
