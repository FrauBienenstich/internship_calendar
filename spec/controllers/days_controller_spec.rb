require 'spec_helper'

describe DaysController do
  render_views

  describe "GET 'welcome'" do

    it 'returns http success' do
      get 'welcome'
      expect(response).to render_template 'welcome'
    end
  end
  
  describe "GET 'index'" do

    before :each do
      @future_day = FactoryGirl.create(:day)
      @past_day = FactoryGirl.create(:day, date: "2000-01-01")

    end

    def test_index_action(params, expected_length)
      get :index, params
      expect {get :index }.to render_template(:index)
      assigns(:days).should_not be_nil
      expect(assigns(:days).length).to eql expected_length
    end

    it "shows past days" do
      test_index_action({past: true}, 1)
    end

    it "shows future days" do
      test_index_action({future: true}, 1)
    end

    it 'shows all days' do
      test_index_action({}, 2)
    end

    
  end

  describe "POST create" do

    before do
      @params = {
        day: {
          date: "2014-04-01"
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
      params = { }

      expect do
        post :create, params
      end.not_to change{ Day.count }
      response.should redirect_to days_path
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
