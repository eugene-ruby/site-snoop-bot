require 'mini_magick'

module Screenshots
  class GridOverlay
    def initialize(image_path)
      @image_path = image_path
    end

    def apply_grid_overlay
      image = MiniMagick::Image.open(@image_path)
      width = image.width
      height = image.height

      grid_width = width / 3
      grid_height = height / 3

      image.combine_options do |c|
        c.fill 'none'
        c.stroke GRID_LINE_COLOR
        c.strokewidth GRID_LINE_WIDTH

        # Draw vertical lines
        (1..2).each do |i|
          x = grid_width * i
          c.draw "line #{x},0 #{x},#{height}"
        end

        # Draw horizontal lines
        (1..2).each do |i|
          y = grid_height * i
          c.draw "line 0,#{y} #{width},#{y}"
        end
      end

      image.write(@image_path)
    end
  end
end
