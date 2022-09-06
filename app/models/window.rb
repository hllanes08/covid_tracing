WINDOW_FRECUENCY = 10
class Window < ApplicationRecord
  belongs_to :user
  scope :today, ->{ where(window_date: Time.zone.now.to_date) }
  scope :on_windows, -> (windows) {
    queries = []
    windows.each do |window|
      queries.push("#{window} = ANY (windows.windows)")
    end
    where(queries.join(' OR '))
  }

  scope :on_date_range, ->(start_date, end_date) {
    where("window_date between ? and ?", start_date, end_date) 
  }

  def self.current_window
    (((Time.zone.now - Time.zone.now.beginning_of_day)/60)/WINDOW_FRECUENCY).to_i
  end

  def elapsed_time
    self.windows.size * WINDOW_FRECUENCY
  end
end
