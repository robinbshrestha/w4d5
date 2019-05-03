require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    describe 'GET#index' do
        it 'renders user index' do
            get :index 
            expect(response).to render_template(:index)
        end
    end

    describe 'GET#new' do 
        it 'brings up form to create a new user' do
            # allow(subject).to receive(:logged_in?).and_return(true)
            get :new 
            expect(response).to render_template(:new)
        end
    end

    describe 'POST#create' do
    before(:each) do 
        create(:user)
        allow(subject).to receive(:current_user).and_return(User.last)
    end

    let(:valid_params) { { user: { username: "rspecguy", password: "helloworld" } } }
    let(:invalid_params) { { user: { nothing: "", nothing: "" } } }
        context 'with valid params' do 
            it 'creates the user' do
                post :create, params: :valid_params 
                expect(User.last.password).to eq("helloworld")
            end
        end
    end
    
end