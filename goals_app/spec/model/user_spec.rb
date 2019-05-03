require 'rails_helper'

RSpec.describe User, type: :model do
    let!(:user) { create(:user) }

    it {should validate_presence_of(:username)}
    it {should validate_presence_of(:session_token)}
    it {should validate_presence_of(:password_digest)}
    it {should validate_length_of(:password).is_at_least(6)}

#      it "creates a password digest when a password is given" do
#     expect(user.password_digest).to_not be_nil
#   end

    describe 'uniqueness' do
        before(:each) do
            create(:user)
        end

        it {should validate_uniqueness_of(:username)}
        it {should validate_uniqueness_of(:session_token)}
        it {should validate_uniqueness_of(:password_digest)}
    end

    
    it "creates a password digest when a password is given" do
        expect(user.password_digest).to_not be_nil
    end
    
    it "creates a session token before validation" do
        user.valid?
        expect(user.session_token).to_not be_nil
    end
    
    describe "#reset_session_token!" do
        it "sets a new session token on the user" do
            user.valid?
            old_session_token = user.session_token
            user.reset_session_token!
            expect(user.session_token).to_not eq(old_session_token)
        end
    end
    
    describe '#is_password?' do
        context 'with valid password' do 
            it 'should return true' do
                expect(user.is_password?('starwars')).to be true
            end
        end
        context 'with invalid password' do 
            it 'should return false' do 
                expect(user.is_password?('gofuckyourself')).to be false
            end
        end
    end

    describe ".find_by_credentials" do
        before { user.save! }

        it "returns user given good credentials" do
            expect(User.find_by_credentials(user.username, "starwars")).to eq(user)
        end

        it "returns nil given bad credentials" do
            expect(User.find_by_credentials("jonathan@fakesite.com", "bad_password")).to eq(nil)
        end
    end
end
