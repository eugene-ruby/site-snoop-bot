require 'fileutils'
require 'securerandom'

module Screenshots
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
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight)")
        sleep 1
        full_page_screenshot(driver, file_path)
      end

      file_path
    end

    private

    def full_page_screenshot(driver, file_path)
      scroll_width = driver.execute_script('return document.body.scrollWidth')
      scroll_height = driver.execute_script('return document.body.scrollHeight')
      
      driver.manage.window.resize_to(scroll_width, scroll_height)
      driver.save_screenshot(file_path)
      
      image = MiniMagick::Image.open(file_path)
      image.colorspace "sRGB"
      image.write(file_path)
    end
  end
end
