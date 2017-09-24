require 'capybara/cucumber'
Capybara.default_driver = :selenium

Given (/^I have access to website$/) do
 visit "http://aravin.net"
end

Then (/^I should see title$/) do
 page.find('.site-title')
end
