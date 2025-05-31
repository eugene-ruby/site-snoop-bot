require 'mini_magick'
require_relative '../../config/constants'

module Screenshots
  class GridOverlay
    def initialize(image_path, columns: 3, rows: 3)
      @image_path = image_path
      @columns = columns
      @rows = rows
    end

    def apply_grid_overlay
      image = MiniMagick::Image.open(@image_path)
      width = image.width
      height = image.height

      grid_width = width / @columns
      grid_height = height / @rows
      pointsize = (grid_height / 3).to_i

      (0..(@rows - 1)).each do |row|
        (0..(@columns - 1)).each do |col|
          x = col * grid_width + grid_width / 2
          y = row * grid_height + grid_height / 2
          number = row * @columns + col + 1

          MiniMagick::Tool::Convert.new do |c|
            c.font 'Arial'
            c.gravity 'NorthWest'
            c.pointsize pointsize
            c.fill GRID_LINE_COLOR
            c.draw "text #{x} #{y} '#{number}'"
            c << @image_path
          end
        end
      end
    end
  end
end
