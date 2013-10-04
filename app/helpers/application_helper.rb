module ApplicationHelper
  def base64_image(image_data)
    begin
      return "<img src='data:image/png;base64,#{Base64.encode64(image_data)}' />".html_safe
    rescue => e
      logger.error "Error encoding" + e.to_s + e.backtrace.join("\n")
    end
  end
end
