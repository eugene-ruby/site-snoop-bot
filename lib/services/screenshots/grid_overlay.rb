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

      image.combine_options do |c|
        c.fill GRID_LINE_COLOR
        c.stroke GRID_LINE_COLOR
        c.strokewidth 2
        c.pointsize pointsize

        (0..(@rows - 1)).each do |row|
          (0..(@columns - 1)).each do |col|
            x = col * grid_width + grid_width / 2
            y = row * grid_height + grid_height / 2
            c.gravity 'center'
            c.draw "text #{x},#{y} '#{row * @columns + col + 1}'"
          end
        end

        (1..(@columns - 1)).each do |i|
          x = grid_width * i
          c.draw "line #{x},0 #{x},#{height}"
        end

        (1..(@rows - 1)).each do |i|
          y = grid_height * i
          c.draw "line 0,#{y} #{width},#{y}"
        end
      end

      image.write(@image_path)
    end
  end
end
