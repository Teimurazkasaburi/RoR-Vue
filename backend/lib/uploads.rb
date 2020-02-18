class Uploads
  class << self
    def jpeg?(blob)
      blob.content_type.include? 'jpeg'
    end

    def optimize
      {
        strip: true
      }
    end

    def optimize_jpeg
     combine_options: {
        strip: true,
        'sampling-factor': '4:2:0',
        quality: '85',
        interlace: 'JPEG',
        colorspace: 'sRGB',
        gravity: 'center'
      }
    end


    def optimize_hash(blob)
      return optimize_jpeg if jpeg? blob
      optimize
    end

    def resize_to_limit(width:, height:, blob:)
      {
        resize: "#{width}x#{height}>"
      }.merge(optimize_hash(blob))
    end

    def resize_to_fit(width:, height:, blob:)
      {
        resize: "#{width}x#{height}"
      }.merge(optimize_hash(blob))
    end

    def thumbnail(blob:)
      combine_options: {
        resize: "300x300^", 
        extent: '300x300',
        gravity: 'center'
      }.merge(optimize_hash(blob))
    end

    def resize_to_fill(width:, height:, blob:, gravity: 'Center')
      blob.analyze unless blob.analyzed?

      cols = blob.metadata[:width].to_f
      rows = blob.metadata[:height].to_f
      if width != cols || height != rows
        scale_x = width / cols
        scale_y = height / rows
        if scale_x >= scale_y
          cols = (scale_x * (cols + 0.5)).round
          resize = cols.to_s
        else
          rows = (scale_y * (rows + 0.5)).round
          resize = "x#{rows}"
        end
      end

      {
        resize: resize,
        gravity: gravity,
        background: 'rgba(255,255,255,0.0)',
        extent: cols != width || rows != height ? "#{width}x#{height}" : ''
      }.merge(optimize_hash(blob))
    end

    def resize_and_pad(width:, height:, blob:, background: :transparent, gravity: 'Center')
      {
        thumbnail: "#{width}x#{height}>",
        background: background == :transparent ? 'rgba(255, 255, 255, 0.0)' : background,
        gravity: gravity,
        extent: "#{width}x#{height}"
      }.merge(optimize_hash(blob))
    end


    def resize_to_fill_watermarked(width:, height:, blob:)
      blob.analyze unless blob.analyzed?

      cols = blob.metadata[:width].to_f
      rows = blob.metadata[:height].to_f
      if width != cols || height != rows
        scale_x = width / cols
        scale_y = height / rows
        if scale_x >= scale_y
          cols = (scale_x * (cols + 0.5)).round
          resize = cols.to_s
        else
          rows = (scale_y * (rows + 0.5)).round
          resize = "x#{rows}"
        end
      end

     combine_options = {
        gravity: 'center',
        resize: "#{width}x#{height}",
        draw: 'image Over 0,0 0,0 "' + Post::WATERMARK_PATH.to_s + '"',
        background: 'rgba(255,255,255,0.0)',
        extent: cols != width || rows != height ? "#{width}x#{height}" : ''
      }.merge(optimize_hash(blob))
    end
  end
end
