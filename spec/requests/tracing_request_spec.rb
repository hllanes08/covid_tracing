require 'rails_helper'

RSpec.describe "Tracings", type: :request do
  include Warden::Test::Helpers
  context 'Validate contact between users' do
    let (:user_1) { User.create(email: Faker::Internet.email, password: 'test123', password_confirmation: 'test123') } 
    let (:user_2) {  User.create(email: Faker::Internet.email, password: 'test123', password_confirmation: 'test123') } 
    let (:user_3) {  User.create(email: Faker::Internet.email, password: 'test123', password_confirmation: 'test123') } 
    before(:each) do
      host! 'localhost'
      #Shared windows from 10 am to 12 pm
      (Time.zone.now.beginning_of_day + 10.hours)
      Window.create(
        user_id: user_1.id,
        contact_user_id: user_2.id,
        window_date: Time.zone.now.to_date,
        windows: [60,61,62,63,64,65,66,67,68,69,70]
      )
      Window.create(
        user_id: user_2.id,
        contact_user_id: user_1.id,
        window_date: Time.zone.now.to_date,
        windows: [60,61,62,63,64,65,66,67,68,69,70]
      )
      #Shared time from 2 pm to 4 pm
      Window.create(
        user_id: user_1.id,
        contact_user_id: user_3.id,
        window_date: Time.zone.now.to_date,
        windows: [84,85.86,87,88,89,90,91,92,93,94,95,96]
      )
      Window.create(
        user_id: user_3.id,
        contact_user_id: user_1.id,
        window_date: Time.zone.now.to_date,
        windows: [84,85.86,87,88,89,90,91,92,93,94,95,96]
      )

      login_as user_1, scope: :user
    end

    it 'Get shared time on today' do
      sign_in user_1
      get '/contacts.json', headers: user_1.create_new_auth_token, params: {
        start_date: Time.zone.now.strftime('%Y-%m-%d'),
        end_date: Time.zone.now.strftime('%Y-%m-%d')
      }
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to eq true
      #User 2 => 100 minutes, User 3 => 120 minutes
      expect(json_response['users']).to eq [[user_2.email, 110],[user_3.email, 120]]
    end
  end
end
