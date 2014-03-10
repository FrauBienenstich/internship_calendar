require 'spec_helper'

describe InternshipsController do
  render_views

  describe 'POST create' do

    context "with valid attributes" do #why do invalid attributes not go into model?

      before do 
        @slot = FactoryGirl.create(:slot)
      end

      #internship: FactoryGirl.attributes_for(:internship)
      it 'creates a new internship and a new person' do
        
        params = {
          email: "susanne@dewein.de",
          name: "Susanne Dewein",
          slot_id: @slot.id,
          description: "Test" 
        }

        expect do
          post :create, params
        end.to change{ Internship.count }.by(1)

        expect do
          post :create, params
        end.to change{ Person.count }.by(1)

        response.should redirect_to current_days_path
      end

      it 'finds assigned host if Person already exists' do
        person = FactoryGirl.create(:person)

        params = {
          email: person.email,
          name: person.name,
          slot_id: @slot.id,
          description: "Test" 
        }

        expect do
          post :create, params
        end.not_to change{ Person.count }

        expect do
          post :create, params
        end.to change{ Internship.count }.by(1)
      end

    end

    context "with invalid attributes" do
      pending
    end
  end

  describe 'PUT update' do

  end


  describe 'DELETE destroy' do

  end

  describe '#assign_intern' do

  end


  describe '#delete_intern' do

  end


  describe 'GET new' do

    before do 
      @slot = FactoryGirl.create(:slot)
    end

    it "renders the new form" do
      get :new, :slot_id => @slot.id
      expect { get :new }.to render_template(:new)
      assigns(:internship).should be_a_new(Internship)
      expect { get :new }.to_not render_template(layout: "application")
    end

  end

  describe 'GET sign_up_form' do

    before do
      @internship = FactoryGirl.create(:internship)
    end

    it "renders the sign_up form" do
      get :sign_up_form, :id => @internship.id
      expect { get :sign_up_form }.to_not render_template(layout: "application")
    end
  end

  describe 'GET edit' do

    before do
      @internship = FactoryGirl.create(:internship)
      @internship.create_intern( FactoryGirl.attributes_for(:intern) ) # WICHTIG!!!
      @internship.save
    end

    it "renders the edit form" do
      get :edit, :id => @internship.id
      expect { get :edit }.to_not render_template(layout: "application")
    end
  end

end
