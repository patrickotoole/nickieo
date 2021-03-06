# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support:
  include CarrierWave::RMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :s3

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  
  def resize_and_crop()
    manipulate! do |img|
      img = img.resize_to_fill(img.columns*3/2,img.columns)
    end
  end
  
  def resize_and_crop_to_square()
    manipulate! do |img|
      img = img.resize_to_fill(img.columns,img.columns)
    end
  end
  
  version :dimension do
    process :resize_and_crop
  end
  
  
  version :square do
    process :resize_to_fill => [200,200]
  end
  
  version :featured do
    process :resize_and_crop
    process :resize_to_limit => [250, 250]
  end
  
  version :thumb do
    process :resize_to_limit => [56, 56]
    process :resize_and_pad => [56,56]
  end
  
  version :onehundred do 
    process :resize_and_pad => [100, 100]
  end
  
  version :thumb_crop do
    process :resize_and_crop_to_square
    process :resize_to_limit => [56, 56]
  end
  
  version :onehundred_crop do 
    process :resize_and_crop_to_square
    process :resize_to_limit => [100, 100]
  end
  
  version :web do
    process :resize_to_limit => [600,600]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # def filename
  #   "something.jpg" if original_filename
  # end

end
