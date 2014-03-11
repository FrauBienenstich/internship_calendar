require 'spec_helper'

describe InternshipsController do
  render_views

  describe 'POST create' do

    context "with valid attributes" do #why do invalid attributes not go into model?

      before do 
        @slot = FactoryGirl.create(:slot)
      end

      context "new person " do

        before do
          @params = {
            email: "susanne@dewein.de",
            name: "Susanne Dewein",
            slot_id: @slot.id,
            description: "Test" 
          }   
        end

        it 'creates a new internship and a new person' do
          expect do
            expect do
              post :create, @params
            end.to change{ Internship.count }.by(1)
          end.to change{ Person.count }.by(1)
          response.should redirect_to current_days_path
        end


        it 'sends out email' do
          internship = double("my Internship").as_null_object
          Internship.stub(:new).and_return(internship)
          PersonMailer.any_instance.should_receive(:confirmation_mail).with(internship)
          post :create, @params

        end
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
      
      it 'renders an error message and does not save' do
        expect do
          post :create, internship: { title: ''}
        end.not_to change{ Internship.count }
        response.should redirect_to current_days_path
        flash[:error].should_not be_blank
      end
    end
  end

  describe 'PUT update' do

    it 'removes an intern from an internship' do
      pending
    end

    it 'adds an intern to an internship' do
      pending
    end
    # should i test the internally called methods separately?(delete_intern, assign_intern)

  end


  describe 'DELETE destroy' do

    # before do
    #   @internship = FactoryGirl.create(:internship)
    # end

    it 'deletes the whole internship' do
      #create a double:
      internship = double("my Internship")

      #stub a method:
      Internship.stub(:find).with("7").and_return(internship)
      internship.should_receive(:destroy).and_return(internship.as_null_object)
      delete :destroy, :id => 7

      # expect{
      #   delete :destroy, id: internship # why can i write it like this?
      # }.to change(Internship, :count).by(-1)



          
      # PersonMailer.any_instance.should_receive(:delete_internship_mail).with(internship)
      # delete :destroy, @params

    end

    it 'sends out an email to intern and host' do
      
    end

    it 'redirects to the current_days_path' do

    end
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
