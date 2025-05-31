module Screenshots
  class GridPreview
    def initialize(url, zoom: nil)
      @url = url
      @zoom = zoom
    end

    def call
      FileUtils.mkdir_p("tmp/screenshots")

      screenshot = Screenshots::Screenshot.new(@url)
      screenshot_path = screenshot.capture

      if @zoom
        zoomed = Screenshots::GridZoom.new(
          screenshot_path,
          columns: @zoom[:columns],
          rows: @zoom[:rows],
          target: @zoom[:target]
        )
        zoomed.zoom
      else
        auto_grid_overlay = Screenshots::AutoGridOverlay.new(screenshot_path)
        columns, rows = auto_grid_overlay.calculate_grid_dimensions

        overlay = Screenshots::GridOverlay.new(screenshot_path, columns: columns, rows: rows)
        overlay.apply_grid_overlay
      end
    end
  end
end
