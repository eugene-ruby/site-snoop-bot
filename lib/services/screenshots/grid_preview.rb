module Screenshots
  class GridPreview
    def initialize(url)
      @url = url
    end

    def call
      screenshot = Screenshots::Screenshot.new(@url)
      screenshot_path = screenshot.capture

      image = MiniMagick::Image.open(screenshot_path)
      width = image.width
      height = image.height

      columns = (width / 300.0).ceil
      rows = (height / 300.0).ceil

      overlay = Screenshots::GridOverlay.new(screenshot_path, columns: columns, rows: rows)
      overlay.apply_grid_overlay

      screenshot_path
    end
  end
end
