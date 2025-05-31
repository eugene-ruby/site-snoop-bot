module Screenshots
  class GridPreview
    def initialize(url, zoom: nil)
      @url = url
      @zoom = zoom
    end

    def call
      if @zoom
        screenshot = Screenshots::Screenshot.new(@url)
        screenshot_path = screenshot.capture

        zoom = @zoom.transform_keys(&:to_sym)
        zoomed_image_path = Screenshots::GridZoom.new(screenshot_path, **zoom).zoom

        overlay = Screenshots::GridOverlay.new(zoomed_image_path, columns: 3, rows: 3)
        overlay.apply_grid_overlay

        zoomed_image_path
      else
        auto_grid_overlay = Screenshots::AutoGridOverlay.new(@url)
        columns, rows = auto_grid_overlay.calculate_grid_dimensions

        screenshot = Screenshots::Screenshot.new(@url)
        screenshot_path = screenshot.capture

        overlay = Screenshots::GridOverlay.new(screenshot_path, columns: columns, rows: rows)
        overlay.apply_grid_overlay

        screenshot_path
      end
    end
  end
end
