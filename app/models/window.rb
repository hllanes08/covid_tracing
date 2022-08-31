WINDOW_FRECUENCY = 10
class Window < ApplicationRecord
  belongs_to :user
  scope :today, ->{ where(window_date: Time.zone.now.to_date) }

  def self.current_window
    (((Time.zone.now - Time.zone.now.beginning_of_day)/60)/WINDOW_FRECUENCY).to_i
  end
end
