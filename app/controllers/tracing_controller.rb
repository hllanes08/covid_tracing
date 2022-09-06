class TracingController < ApplicationController

  def index
  end

  def contacts
    user_windows = current_user.windows.on_date_range(params[:start_date] ,params[:end_date])
    #Windows not assigned to current user
    contact_windows = Window.on_date_range(params[:start_date], params[:end_date]).where("user_id != ?", current_user.id)
    shared_users = []
    user_windows.group_by{ |w| w.window_date }.each do |window_date, items|
      shared_windows = items.map(&:windows).uniq.flatten
      contact_windows.where(window_date: window_date).on_windows(shared_windows).group_by{ |w| w.user }.each do |user, _items|
        shared_users << [user.email, _items.sum(&:elapsed_time)]
      end
    end

    respond_to do |format|
      format.json {
        render json: {
          success: true,
          users: shared_users
        }, status: :ok
      }
      format.html
    end
  end

end
