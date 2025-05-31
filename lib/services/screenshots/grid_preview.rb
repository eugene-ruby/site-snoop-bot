module Screenshots
  class GridPreview
    def initialize(url)
      @url = url
    end

    def call
      screenshot = Screenshots::Screenshot.new(@url)
      screenshot_path = screenshot.capture

      overlay = Screenshots::GridOverlay.new(screenshot_path)
      overlay.apply_grid_overlay

      screenshot_path
    end
  end
end
