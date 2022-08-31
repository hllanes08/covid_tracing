require 'rails_helper'
require 'faker'

RSpec.describe "Api::Windows", type: :request do
  context 'Validate create and add new window' do
    let (:user_1) { User.create(email: Faker::Internet.email, password: 'test123', password_confirmation: 'test123') } 
    let (:user_2) {  User.create(email: Faker::Internet.email, password: 'test123', password_confirmation: 'test123') } 
    let (:user_3) {  User.create(email: Faker::Internet.email, password: 'test123', password_confirmation: 'test123') } 
    before(:each) do
      host! 'localhost'
    end

    it 'Create a new window' do
      post '/api/window', headers: user_1.create_new_auth_token, params: {
        user_ids: [user_2.id]
      }
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to eq true
      expect(user_1.windows.today.size).to eq 1
    end

    it 'Create window for multiples user contacts' do
      post '/api/window', headers: user_1.create_new_auth_token, params: {
        user_ids: [user_2.id, user_3.id]
      }
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to eq true
      expect(user_1.windows.today.size).to eq 2
    end

    it 'Create just on window for multiples reports' do
      post '/api/window', headers: user_1.create_new_auth_token, params: {
        user_ids: [user_2.id, user_2.id]
      }
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to eq true
      expect(user_1.windows.today.size).to eq 1

    end
  end
end
