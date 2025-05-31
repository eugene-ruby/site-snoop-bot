module Screenshots
  class AutoGridOverlay
    def initialize(image_path, target_cell_size:)
      @image_path = image_path
      @target_cell_size = target_cell_size
    end

    def calculate_grid_dimensions
      image = MiniMagick::Image.open(@image_path)
      width = image.width
      height = image.height

      columns = (width / @target_cell_size.to_f).ceil
      rows = (height / @target_cell_size.to_f).ceil

      [columns, rows].map { |v| [v, GRID_MAX].min }
    end
  end
end
