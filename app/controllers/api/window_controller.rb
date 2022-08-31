class Api::WindowController < ApplicationController

  def create
    windows = []
    params[:user_ids].each do |user_id|
      window = Window.today.where(user_id: current_user.id, contact_user_id: user_id)
      if window.any?
        window = window.first
      else
        window = Window.new(user_id: current_user.id, contact_user_id: user_id, window_date: Time.zone.now.to_date) 
      end
      window.windows = window.windows + [Window.current_window]
      window.save!
      windows << window
    end
    render json: {
      success: true,
      windows: windows
    }
  end

  private

  def window_params
    parmas.require(:window).permit(:window, :contact_user_id, :user_id)
  end
end
