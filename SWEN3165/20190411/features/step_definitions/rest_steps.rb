require 'httparty'
When /^the client requests GET (.*)$/ do |path|
  @last_response = HTTParty.get('https://localhost:5000' + path)
end
Then /^the response should be JSON:$/ do |json|
  JSON.parse(@last_response.body).should == JSON.parse(json)
end

