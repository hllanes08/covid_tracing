WINDOW_FRECUENCY = 10
class Window < ApplicationRecord
  def self.current_window
    (((Time.zone.now - Time.zone.now.beginning_of_day)/60)/WINDOW_FRECUENCY).to_i
  end
end
