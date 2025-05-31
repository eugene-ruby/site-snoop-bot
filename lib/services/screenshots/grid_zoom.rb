require 'fileutils'
require 'securerandom'
require 'mini_magick'

module Screenshots
  class GridZoom
    def initialize(screenshot_path, columns:, rows:, target:)
      @screenshot_path = screenshot_path
      @columns = columns
      @rows = rows
      @target = target
    end

    def zoom
      image = MiniMagick::Image.open(@screenshot_path)
      width = image.width
      height = image.height

      cell_width = width / @columns
      cell_height = height / @rows

      col = (@target - 1) % @columns
      row = (@target - 1) / @columns

      x = col * cell_width
      y = row * cell_height

      cropped_image_path = "tmp/screenshots/cropped_#{SecureRandom.hex(5)}_#{Time.now.to_i}.png"

      # Вырезаем и сохраняем
      # Принудительно устанавливаем цветовое пространство в sRGB,
      # чтобы избежать ошибок при сохранении PNG с белым (grayscale) содержимым:
      # ImageMagick может сохранить такую картинку в grayscale с RGB-профилем,
      # что вызывает конфликт: "RGB color space not permitted on grayscale PNG"

      MiniMagick::Tool::Convert.new do |convert|
        convert << @screenshot_path
        convert.crop "#{cell_width}x#{cell_height}+#{x}+#{y}"
        convert.repage.+
        convert.colorspace "sRGB"
        convert << cropped_image_path
      end

      overlay = Screenshots::GridOverlay.new(cropped_image_path, columns: 3, rows: 3)
      output_path = overlay.apply_grid_overlay
      FileUtils.rm_f(cropped_image_path)

      output_path
    end
  end
end
