module Features
  module DebugHelpers
    def save_and_open_screenshot(unique = false)
    name = (unique ? Time.now.to_i.to_s : "")
    name = "screenshot_#{name}.png"
    path = Rails.root.join('tmp', name).to_s
    page.save_screenshot(path, :full => true)
    Launchy.open path
    end
  end
end