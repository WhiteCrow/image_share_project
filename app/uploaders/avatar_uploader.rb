# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  Filters = ["lomo_filter", "kelvin_filter", "colortone_filter", "gotham_filter"]

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def lomo_filter
    manipulate! do |img|
      img.channel 'R'
      img.level '22%'
      img.channel 'G'
      img.level '22%'

      img = yield(img) if block_given?
      img
    end
  end

  def kelvin_filter
    manipulate! do |img|
      cols, rows = img[:dimensions]

      img.combine_options do |cmd|
        cmd.auto_gamma
        cmd.modulate '120,50,100'
      end

      new_img = img.clone
      new_img.combine_options do |cmd|
        cmd.fill 'rgba(255,153,0,0.5)'
        cmd.draw "rectangle 0,0 #{cols},#{rows}"
      end

      img = img.composite new_img do |cmd|
        cmd.compose 'multiply'
      end

      img = yield(img) if block_given?
      img
    end
  end

  def colortone_filter(color = '#222b6d', level = 100, type = 0)
    manipulate! do |img|
      color_img = img.clone
      color_img.combine_options do |cmd|
        cmd.fill color
        cmd.colorize '63%'
      end

      img = img.composite color_img do |cmd|
        cmd.compose 'blend'
        cmd.define "compose:args=#{level},#{100-level}"
      end

      img = yield(img) if block_given?
      img
    end
  end

  def gotham_filter
    manipulate! do |img|
      img.modulate '120,10,100'
      img.fill '#222b6d'
      img.colorize 20
      img.gamma 0.5
      img.contrast

      img = yield(img) if block_given?
      img
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
