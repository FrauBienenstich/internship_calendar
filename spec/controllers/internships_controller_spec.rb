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
              expect(assigns[:slot]).not_to be_nil
            end.to change{ Internship.count }.by(1)
          end.to change{ Person.count }.by(1)
          response.should redirect_to day_path(@slot.day)
        end


        it 'sends out email' do

          ical = Icalendar::Calendar.new.to_ical
          internship = double("my Internship").as_null_object
          Internship.stub(:new).and_return(internship)
          internship.stub(:to_ical).and_return(ical)
          PersonMailer.any_instance.should_receive(:confirmation_mail).with(internship, ical)
          #puts @params
          post :create, @params
        end

        it 'sends out email 2' do
          expect {            
            post :create, @params
            mail = ActionMailer::Base.deliveries.last
            mail.subject.should match /successfully created/
            mail.attachments.first.filename.should match /ics/
          }.to change { ActionMailer::Base.deliveries.size }.by(1)
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
      #why does this not go into model spec?
      it 'renders an error message and does not save' do
        expect do
          post :create, internship: { title: ''}
        end.not_to change{ Internship.count }
        response.should redirect_to days_path
        flash[:error].should_not be_blank
      end
    end
  end

  describe 'PUT update' do

    before do
      @internship = double("my internship")
      Internship.stub(:find_by).with(id: "12").and_return(@internship)
      @slot = double('slot')
      @day = double('day')
      @internship.stub(:slot).and_return(@slot)
      @slot.stub(:day).and_return(@day)
    end

    context "when deleting an intern from an internship" do

      it 'removes an intern from an internship' do
        @internship.should_receive(:delete_intern!).and_return(@internship.as_null_object)
        put :update, id: 12, commit: "Remove"
      end

      it 'shows a succes flash' do
      end

      
      it 'redirects to day path' do
        @internship.stub(:delete_intern).and_return(@internship.as_null_object)
        put :update, id: 12, commit: "Remove"
        response.should redirect_to day_path(@internship.slot.day)
      end
    end

    context "when assigning an intern to an internship" do

      it 'adds an intern to an internship' do
        @internship.should_receive(:assign_intern).and_return(@internship.as_null_object)
        put :update, id: 12
      end

      it 'redirects to day path' do
        @internship.stub(:assign_intern).and_return(@internship.as_null_object)
        put :update, id: 12
        response.should redirect_to day_path(@internship.slot.day)
      end
    end
  end


  describe 'DELETE destroy' do

    it 'deletes the whole internship' do
      internship = double("my Internship")
      Internship.stub(:find).with("7").and_return(internship)
      internship.should_receive(:destroy).and_return(internship.as_null_object)
      delete :destroy, :id => 7
    end


    it 'sends out an email to intern and host' do
      internship = double("my Internship").as_null_object
      Internship.stub(:find).with("8").and_return(internship)

      PersonMailer.any_instance.should_receive(:delete_internship_mail).with(internship)

      delete :destroy, id: 8
    end

    it 'redirects to the day_path' do
      internship = double("my Internship").as_null_object
      Internship.stub(:find).with("9").and_return(internship)
      delete :destroy, id: 9
      expect(response).to redirect_to day_path(internship.slot.day)#i am confused why this works(internship.slot.day) where do slot and day come from?
    end
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
