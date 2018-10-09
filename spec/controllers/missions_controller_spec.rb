require 'rails_helper'
require 'locale_helpers'


RSpec.describe MissionsController, type: :controller do

  before(:each) do
    reset_locale 'en_test'
    request.headers["LANG"] = "en_test"
  end

  # This should return the minimal set of attributes required to create a valid
  # Mission. As you add validations to Mission, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {title: 'myTitle', instructions: 'ay 7aga', category: 'home', duration: 12}
  }

  let(:first_en_valid_attributes) {
    {title: 'first english mission title', instructions: 'ay 7aga', category: 'home', duration: 12}
  }
  let(:second_en_valid_attributes) {
    {title: 'second english mission title', instructions: 'ay 7aga', category: 'home', duration: 12}
  }

  let(:ar_valid_attributes) {
    {title: 'عنوان', instructions: 'التفاصيل', category: 'منزل', duration: 12}
  }

  let(:invalid_attributes) {
    {title: '', instructions: '', category: '', duration: ''}
  }


  describe 'GET #by_lang' do
    it 'retrieves all missions in a specific language' do
      first_mission = Mission.create! first_en_valid_attributes
      second_mission = Mission.create! second_en_valid_attributes
      reset_locale "ar_test"
      third__mission = Mission.create! valid_attributes
      fourth_mission = Mission.create! valid_attributes

      request.headers["LANG"] = "en_test"
      get :by_lang

      missions = assigns(:missions)
      expect(missions.length).to eql(2)
      expect(missions[0].id).to eql(first_mission.id)
      expect(missions[0].title).to eql(first_en_valid_attributes[:title])
      expect(missions[1].id).to eql(second_mission.id)
      expect(missions[1].title).to eql(second_en_valid_attributes[:title])
    end
  end

  describe 'GET #index' do
    it 'returns a success response' do
      Mission.create! valid_attributes
      get :index
      expect(response).to be_successful
    end

    it 'should return all missions in all languages' do
      reset_locale 'en_test'
      first_mission = Mission.create! valid_attributes

      reset_locale 'ar_test'
      first_mission.title = ar_valid_attributes[:title]
      first_mission.instructions = ar_valid_attributes[:instructions]
      first_mission.save

      reset_locale 'sp_test'
      first_mission.title = valid_attributes[:title] + 'sp'
      first_mission.instructions = valid_attributes[:instructions] + 'sp'
      first_mission.save

      get :index

      missions = assigns(:missions)
      expect(missions.length).to eql(3)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      mission = Mission.create! valid_attributes
      get :show, params: {id: mission.to_param}
      expect(response).to be_successful
    end
  end
  #
  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end
  #
  describe 'GET #edit' do
    it 'returns a success response' do
      mission = Mission.create! valid_attributes
      get :edit, params: {id: mission.to_param}
      expect(response).to be_successful
    end
  end
  #
  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Mission' do
        expect {
          post :create, params: {mission: valid_attributes}
        }.to change(Mission, :count).by(1)
      end

      it 'redirects to the created mission' do
        post :create, params: {mission: valid_attributes}
        expect(response).to redirect_to('/')
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e. to display the \'new\' template)' do
        post :create, params: {mission: invalid_attributes}
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        {title: 'new_title', instructions: 'new_instructions', category: 'new_category', duration: 10}
      }

      it 'updates the requested mission' do
        mission = Mission.create! valid_attributes
        put :update, params: {id: mission.to_param, mission: new_attributes}
        mission.reload
        expect(mission.title).to eql('new_title')
        expect(mission.instructions).to eql('new_instructions')
        expect(mission.category).to eql('new_category')
        expect(mission.duration).to eql(10)
      end

      it 'redirects to the mission' do
        mission = Mission.create! valid_attributes
        put :update, params: {id: mission.to_param, mission: valid_attributes}
        expect(response).to redirect_to('/')
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e. to display the \'edit\' template)' do
        mission = Mission.create! valid_attributes
        put :update, params: {id: mission.to_param, mission: invalid_attributes}
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested mission' do
      mission = Mission.create! valid_attributes
      expect {
        delete :destroy, params: {id: mission.to_param}
      }.to change(Mission, :count).by(-1)
    end

    it 'redirects to the missions list' do
      mission = Mission.create! valid_attributes
      delete :destroy, params: {id: mission.to_param}
      expect(response).to redirect_to(missions_url)
    end
  end

  after(:all) do
    remove_locale_file 'en_test'
    remove_locale_file 'ar_test'
    remove_locale_file 'sp_test'
  end
end
