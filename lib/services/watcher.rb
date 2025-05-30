require 'selenium-webdriver'

class Watcher
  def initialize(url, css_selector)
    @url = url
    @css_selector = css_selector
    @driver = Selenium::WebDriver.for :chrome, options: Selenium::WebDriver::Options.chrome(args: ['headless'])
  end

  def fetch_content
    @driver.navigate.to @url
    element = @driver.find_element(css: @css_selector)
    element.text
  ensure
    @driver.quit
  end
end
