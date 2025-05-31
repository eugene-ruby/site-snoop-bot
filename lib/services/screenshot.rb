require 'fileutils'
require 'securerandom'

module Screenshot
  class Screenshot
    def initialize(url)
      @url = url
    end

    def capture
      FileUtils.mkdir_p('tmp/screenshots')
      file_path = "tmp/screenshots/#{SecureRandom.hex(5)}_#{Time.now.to_i}.png"

      browser = Snoop::Browser.new
      browser.with_driver do |driver|
        driver.get(@url)
        driver.save_screenshot(file_path)
      end

      file_path
    end
  end
end
