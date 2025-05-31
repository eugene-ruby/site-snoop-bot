require 'sidekiq'
require 'selenium-webdriver'
require 'digest'
require 'tmpdir'

class CheckTaskWorker
  include Sidekiq::Worker

  def perform(snapshot_id)
    snapshot = Snapshot[snapshot_id]
    with_driver do |driver|
      content = extract_content(driver, snapshot.url, snapshot.attribute_query)
      process_snapshot(snapshot, content)
    end
  end

  private

  def with_driver
    Dir.mktmpdir do |user_data_dir|
      options = Selenium::WebDriver::Options.chrome(
        args: [
          'headless',
          '--no-sandbox',
          '--disable-dev-shm-usage',
          "--user-data-dir=#{user_data_dir}"
        ]
      )

      driver = Selenium::WebDriver.for :chrome, options: options
      driver.manage.timeouts.page_load = 10
      driver.manage.timeouts.implicit_wait = 10
      yield(driver)
    rescue Selenium::WebDriver::Error::TimeoutError,
      Selenium::WebDriver::Error::NoSuchElementError => e
      handle_error(e)
    ensure
      driver.quit if driver
    end
  end

  def extract_content(driver, url, attribute_query)
    driver.navigate.to url
    # Пример: attribute_query = 'data-qa="title"'
    if attribute_query =~ /(.+?)=["']?([^"']+)["']?/
      attribute = Regexp.last_match(1)
      value = Regexp.last_match(2)
      element = driver.find_element(xpath: "//*[@#{attribute}='#{value}']")
      element.text
    else
      raise ArgumentError, "Некорректный формат запроса атрибута: #{attribute_query}"
    end
  end

  def process_snapshot(snapshot, content)
    hash = content_hash(content)

    if snapshot.content_hash != hash
      preview = content.split[0, 100].join(' ')
      Notifier.call(chat_id: snapshot.chat_id, message: "Контент изменился. Новое содержимое:\n#{preview}")
      snapshot.update(content_hash: hash, last_checked_at: Time.now)
    else
      snapshot.update(last_checked_at: Time.now)
    end
  end

  def content_hash(text)
    Digest::SHA256.hexdigest(text)
  end

  def handle_error(error)
    Bot::SiteSnoopBot.logger.error("Ошибка: #{error.message}")
  end
end
