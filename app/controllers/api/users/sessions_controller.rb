class Api::Users::SessionsController < DeviseTokenAuth::SessionsController
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def create
    super
  end

  def render_create_success
    render json: {
      success: true,
      user: @resource
    }
  end

   def render_create_error_bad_credentials
    render json: { success: false, errors: "Credentials bad" }, status: :unauthorized
   end
end
