require 'spec_helper'

describe DaysController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to render_template 'index'
    end
  end

  describe "POST create" do

    before do
      @params = {
        day: {
          "date(1i)" => 2000,
          "date(2i)" => 10,
          "date(3i)" => 1
        }
      }
    end

    it 'creates a new day' do
      expect do
        post :create, @params
      end.to change{ Day.count }
      response.should redirect_to days_path
      flash[:notice].should_not be_blank
    end

    it 'does not create the same day again' do
      post :create, @params

      expect do
        post :create, @params
      end.not_to change{ Day.count }
      response.should redirect_to days_path
      flash[:error].should_not be_blank
    end

    it 'renders a flash message if not saved' do

      params = {

      }

      expect do
        post :create, params
      end.not_to change{ Day.count }
      flash[:error].should_not be_blank
    end
  end

  describe "GET new" do
    it 'renders the new form' do
      get :new
      expect {get :new }.to render_template(:new)
      assigns(:day).should be_a_new(Day)
      expect {get :new }.to_not render_template(layout: "application")
    end
  end

  describe "GET show" do
    it 'renders a single day ' do
      day = FactoryGirl.create(:day)
      get :show, id: day.id
      expect {get :show }.to render_template(:show)
      response.should be_success
      assigns(:day).should eql day
    end
  end

  describe "DELETE destroy" do

    it 'deletes a given day' do
      day = double("the_day")
      Day.stub(:find).with("10").and_return(day)
      day.should_receive(:destroy).and_return(day.as_null_object)
      delete :destroy, id: 10
    end

    it 'redirects to the days_path and renders a flash message' do
      day = double("the_day").as_null_object
      Day.stub(:find).with("10").and_return(day)
      delete :destroy, id: 10
      expect(response).to redirect_to days_path
      flash[:notice].should_not be_blank
    end
  end
end
