require 'mini_magick'

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
      pointsize = (grid_height * 0.4).to_i

      draw_commands = []

      # Вертикальные линии
      (1...@columns).each do |i|
        x = i * grid_width
        draw_commands << "line #{x},0 #{x},#{height}"
      end

      # Горизонтальные линии
      (1...@rows).each do |i|
        y = i * grid_height
        draw_commands << "line 0,#{y} #{width},#{y}"
      end

      # Номера
      (0...@rows).each do |row|
        (0...@columns).each do |col|
          number = row * @columns + col + 1
          x = col * grid_width + grid_width / 2
          y = row * grid_height + grid_height / 2
          draw_commands << "text #{x - (pointsize / 3)},#{y + (pointsize / 3)} '#{number}'"
        end
      end

      output_path = "tmp/screenshots/overlay_#{SecureRandom.hex(5)}_#{Time.now.to_i}.png"

      MiniMagick::Tool::Convert.new do |convert|
        convert << @image_path
        convert.fill GRID_LINE_COLOR
        convert.stroke GRID_LINE_COLOR
        convert.strokewidth 2
        convert.font 'Arial'
        convert.pointsize pointsize
        convert.draw(draw_commands.join(" "))
        convert << output_path
      end

      output_path
    end
  end
end
