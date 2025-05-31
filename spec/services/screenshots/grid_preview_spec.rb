require 'spec_helper'
require 'fileutils'

RSpec.describe Screenshots::GridPreview do
  let(:source_image_path) { "spec/fixtures/screenshots/sample.png" }
  let(:stubbed_screenshot) { instance_double(Screenshots::Screenshot, capture: source_image_path) }

  before do
    allow(Screenshots::Screenshot).to receive(:new).and_return(stubbed_screenshot)
  end

  def image_hash(path)
    image = MiniMagick::Image.open(path)
    pixels = image.get_pixels.flatten.pack("C*")
    Digest::SHA256.hexdigest(pixels)
  end

  describe "#call (auto grid)" do
    it "renders correct grid overlay on screenshot" do
      output_path = described_class.new("https://example.com").call

      expect(image_hash(output_path)).to eq(
                                           image_hash("spec/fixtures/screenshots/sample_with_grid.png")
                                         )

      FileUtils.rm_f(output_path)
    end
  end

  describe "#call (zoom)" do
    it "renders grid overlay on selected cropped area" do
      output_path = described_class.new(
        "https://example.com",
        zoom: { columns: 8, rows: 10, target: 14 }
      ).call

      expect(image_hash(output_path)).to eq(
                                           image_hash("spec/fixtures/screenshots/sample_zoom_target_14.png")
                                         )

      FileUtils.rm_f(output_path)
    end
  end
end
