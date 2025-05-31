module Snoop
  class Browser
    def initialize(timeout: 10)
      options = Selenium::WebDriver::Options.chrome(
        args: [
          'headless',
          '--no-sandbox',
          '--disable-dev-shm-usage',
          "--user-data-dir=#{Dir.tmpdir}"
        ]
      )
      @driver = Selenium::WebDriver.for :chrome, options: options
      @driver.manage.timeouts.page_load = timeout
      @driver.manage.timeouts.implicit_wait = timeout
    end

    def with_driver
      yield(@driver)
    ensure
      @driver.quit
    end
  end
end
