require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  # The describe command sets up a grouping of tests.
  describe "grams#destroy" do
    it "shouldn't allow users who didn't create the gram to destroy it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, :id => gram.id
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users destroy a gram" do
      gram = FactoryGirl.create(:gram)
      delete :destroy, :id => gram.id
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy grams" do
      gram = FactoryGirl.create(:gram)
      # Sign in the user that create the gram (the :gram factory has a :user association):
      sign_in gram.user
      delete :destroy, :id => gram.id
      expect(response).to redirect_to root_path
      # Fetch the record with the find_by_id method:
      g = Gram.find_by_id(gram.id)
      expect(g).to eq nil
    end

    it "should return a 404 message if we cannot find a gram with the id that is specified" do
      user = FactoryGirl.create(:user)
      sign_in user
      delete :destroy, :id => "SPACEDUCK"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#update" do
    it "shouldn't let users who didn't create the gram update it" do
      gram = FactoryGirl.create(:gram)
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, :id => gram.id, :gram => { :message => "Wahoo" }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users create a gram" do
      gram = FactoryGirl.create(:gram)
      patch :update, :id => gram.id, :gram => { :message => "Hello" }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update grams" do
      gram = FactoryGirl.create(:gram, :message => "Initial Value")
      sign_in gram.user
      patch :update, :id => gram.id, :gram => { :message => "Changed" }
      expect(response).to redirect_to root_path
      # Need to reload the gram item from our database to check for the updated message value, because the object that is loaded in memory is not updated when we change the database.
      gram.reload
      expect(gram.message).to eq "Changed"
    end

    it "should have http 404 error if the gram cannot be found" do
      user = FactoryGirl.create(:user)
      sign_in user
      patch :update, :id => "YOLOSWAG", :gram => { :message => "Changed" }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      gram = FactoryGirl.create(:gram, :message => "Initial Value")
      sign_in gram.user
      patch :update, :id => gram.id, :gram => { :message => "" }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq "Initial Value"
    end
  end

  describe "grams#edit" do
    it "should shouldn't let a user who did not create the gram edit a gram" do
      gram = FactoryGirl.create(:gram)
      # The user created below will be distinct from the user connected to the gram created above.
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, :id => gram.id
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users edit a gram" do
      gram = FactoryGirl.create(:gram)
      get :edit, :id => gram.id
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the gram is found" do
      gram = FactoryGirl.create(:gram)
      sign_in gram.user
      get :edit, :id => gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the gram is not found" do
      user = FactoryGirl.create(:user)
      sign_in user
      get :edit, :id => "TACOCAT"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#show" do
    it "should successfully show the page if the gram is found" do
      gram = FactoryGirl.create(:gram)
      get :show, :id => gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do
      get :show, :id => "TACOCAT"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#index" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#create" do
    it "should require users to be logged in" do
      post :create, :gram => { :message => "Hello" }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new gram in our database" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, :gram => {
        :message => "Hello!",
        # Simulate uploading a picture from the fixtures folder.
        # Inside the specs themselves the fixture_file_upload method automatically looks inside the right spec/fixtures folder, unlike within factories.rb.
        :picture => fixture_file_upload("/picture.jpg", "image/jpg")
      }

      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      # Ensure the user_id on the gram matches the signed in user's id:
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user

      gram_count = Gram.count
      post :create, :gram => { :message => "" }
      expect(response).to have_http_status(:unprocessable_entity)

      expect(Gram.count).to eq Gram.count
    end
  end
end
