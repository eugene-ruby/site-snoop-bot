require 'sidekiq'
require_relative '../snoop/browser'

class CheckTaskWorker
  include Sidekiq::Worker

  def perform(snapshot_id)
    snapshot = Snapshot[snapshot_id]
    return unless snapshot

    begin
      browser = Snoop::Browser.new
      content = browser.with_driver do |driver|
        url = snapshot.url
        attribute_query = snapshot.attribute_query
        driver.get(url)
        extract_content(driver, url, attribute_query)
      end

      process_snapshot(snapshot, content)
    rescue Snoop::Browser::Error => e
      Bot::Logger.logger.warn("Элемент не найден по запросу: '#{attribute_query}' на странице #{url} (snapshot_id: #{snapshot.id})")
      snapshot.update(last_checked_at: Time.now)
      handle_error(e)
    end
  end

  def extract_content(driver, url, attribute_query)
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
    Bot::Logger.logger.error("Ошибка: #{error.message}")
  end
end
