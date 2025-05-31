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

      image.combine_options do |c|
        c.fill 'none'
        c.stroke GRID_LINE_COLOR
        c.strokewidth GRID_LINE_WIDTH

        # Draw vertical lines
        (1..(@columns - 1)).each do |i|
          x = grid_width * i
          c.draw "line #{x},0 #{x},#{height}"
        end

        # Draw horizontal lines
        (1..(@rows - 1)).each do |i|
          y = grid_height * i
          c.draw "line 0,#{y} #{width},#{y}"
        end

        # Add cell numbers
        cell_number = 1
        (0..(@rows - 1)).each do |row|
          (0..(@columns - 1)).each do |col|
            x = col * grid_width + grid_width / 4
            y = row * grid_height + grid_height / 4
            c.fill GRID_LINE_COLOR
            c.draw "text #{x},#{y} '#{cell_number}'"
            cell_number += 1
          end
        end
      end

      image.write(@image_path)
    end
  end
end
