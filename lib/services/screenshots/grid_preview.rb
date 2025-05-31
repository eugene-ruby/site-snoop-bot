module Screenshots
  class GridPreview
    def initialize(url, columns: 3, rows: 3)
      @url = url
      @columns = columns
      @rows = rows
    end

    def call
      screenshot = Screenshots::Screenshot.new(@url)
      screenshot_path = screenshot.capture

      overlay = Screenshots::GridOverlay.new(screenshot_path, columns: @columns, rows: @rows)
      overlay.apply_grid_overlay

      screenshot_path
    end
  end
end
