module Screenshots
  class AutoGridOverlay
    def initialize(image_path)
      @image_path = image_path
    end

    def calculate_grid_dimensions
      image = MiniMagick::Image.open(@image_path)
      width = image.width
      height = image.height

      columns = (width / 300.0).ceil
      rows = (height / 300.0).ceil

      columns = [columns, 10].min
      rows = [rows, 10].min

      [columns, rows]
    end
  end
end
