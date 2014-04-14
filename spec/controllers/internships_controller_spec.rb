require 'spec_helper'

describe InternshipsController do
  render_views

  describe 'POST create' do

    context "with valid attributes" do #why do invalid attributes not go into model?

      before do 
        @day = FactoryGirl.create(:day)
      end

      context "new person " do

        before do

          @params = {
            email: "susanne@dewein.de",
            name: "Susanne Dewein",
            day_id: @day.id,
            description: "Test",
            internship: {
              "start_time(1i)" => 2014,
              "start_time(2i)" => 4,
              "start_time(3i)" => 21,
              "start_time(4i)" => 15,
              "start_time(5i)" => 10,
              "end_time(1i)" => 2014,
              "end_time(2i)" => 4,
              "end_time(3i)" => 21,
              "end_time(4i)" => 16,
              "end_time(5i)" => 10
            }
          }   
        end

        it 'creates a new internship and a new person' do
          expect do
            expect do
              post :create, @params
            end.to change{ Internship.count }.by(1)
          end.to change{ Person.count }.by(1)
        end

        it 'redirects to the day path' do
          post :create, @params
          response.should redirect_to day_path(@day)
        end

        #test also other redirects


        it 'sends out email' do
          # ical = Icalendar::Calendar.new.to_ical
          internship = double("my Internship").as_null_object
          Internship.stub(:new).and_return(internship)
          # internship.stub(:to_ical).and_return(ical)
          PersonMailer.any_instance.should_receive(:confirmation_mail).with(internship)
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
          day_id: @day.id,
          description: "Test", 
          internship: {
            "start_time(1i)" => 2014,
            "start_time(2i)" => 4,
            "start_time(3i)" => 21,
            "start_time(4i)" => 15,
            "start_time(5i)" => 10,
            "end_time(1i)" => 2014,
            "end_time(2i)" => 4,
            "end_time(3i)" => 21,
            "end_time(4i)" => 16,
            "end_time(5i)" => 10
          }
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

      before do
        @day = FactoryGirl.create(:day)
        
            @params = {

              email: "susanne@dewein.de",
              name: "Susanne Dewein",
              day_id: @day.id,
              description: "",
              internship: {
              "start_time(1i)" => 2014,
              "start_time(2i)" => 4,
              "start_time(3i)" => 21,
              "start_time(4i)" => 15,
              "start_time(5i)" => 10,
              "end_time(1i)" => 2014,
              "end_time(2i)" => 4,
              "end_time(3i)" => 21,
              "end_time(4i)" => 16,
              "end_time(5i)" => 10
              }
            }   
          end

      #why does this not go into model spec?
      it 'renders an error message and does not save' do
        expect do
          post :create, @params
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

      @ical = double('ical')
      @internship.stub(:to_ical).and_return(@ical)

      @day = double('day')
      @mailer = double('mailer')
      @internship.stub(:day).and_return(@day)

      PersonMailer.stub(:assign_intern_mail).and_return(@mailer)

      PersonMailer.stub(:confirmation_for_intern_mail).and_return(@mailer)

      @email = "susanne.dewein@gmail.com"
      @name = "Susanne Dewein"
      

    end

    context "when assigning and intern" do
      context "in case of success" do

        it 'adds an intern to an internship' do
          @internship.should_receive(:assign_intern).with(@email, @name).and_return(true)
          @mailer.should_receive(:deliver).twice
          put :update, id: 12, email: @email, name: @name
        end

        it 'redirects to day path' do
          @internship.stub(:assign_intern).and_return(true)
          @mailer.should_receive(:deliver).twice
          put :update, id: 12, email: @email, name: @name
          response.should redirect_to day_path(@internship.day)
        end

        it 'sends out emails' do
          @internship.stub(:assign_intern).and_return(true)
          @mailer.should_receive(:deliver).twice
          PersonMailer.should_receive(:assign_intern_mail).with(@internship)
          put :update, id: 12, email: @email, name: @name
        end

        it "shows a success flash" do
          @internship.stub(:assign_intern).and_return(true)
          @mailer.should_receive(:deliver).twice
          put :update, id: 12, email: @email, name: @name
          flash[:notice].should_not be_blank
        end

      end

      context "in case of error" do

        before do

          @internship = double("my internship")
          Internship.stub(:find_by).with(id: "12").and_return(@internship)

          @ical = double('ical')
          @internship.stub(:to_ical).and_return(@ical)

          @day = double('day')
          @mailer = double('mailer')
          @internship.stub(:day).and_return(@day)

          PersonMailer.stub(:assign_intern_mail).and_return(@mailer)

          PersonMailer.stub(:confirmation_for_intern_mail).and_return(@mailer)

          @internship.stub(:errors).and_return(ActiveModel::Errors.new(@internship))
        end

        it "should not send an email" do
          @internship.stub(:assign_intern).and_return(false)
          @mailer.should_not_receive(:deliver)
          PersonMailer.should_not_receive(:assign_intern_mail).with(@internship)
          put :update, id: 12, email: "", name: ""
        end

        it "shows an error flash" do
          @internship.stub(:assign_intern).and_return(false)
          put :update, id: 12, email: "", name: ""
          flash[:error].should_not be_blank
        end
      end

    end

    # context "when deleting an intern" do
    #   context "in case of success" do

    #     it 'removes an intern from an internship' do
    #       @internship.should_receive(:delete_intern!).and_return(@internship.as_null_object)
    #       put :update, id: 12, commit: "Remove"
    #     end

    #     it 'redirects to day path' do
    #       @internship.stub(:delete_intern).and_return(@internship.as_null_object)
    #       put :update, id: 12, commit: "Remove"
    #       response.should redirect_to day_path(@internship.slot.day)
    #     end
    #   end
    # end
  end


  describe 'PUT update without stubbing' do
    context "if user wants to delete intern" do
      let(:internship) { 
        intern = FactoryGirl.create(:intern)
        internship = FactoryGirl.create(:internship) 
        internship.assign_intern(intern.email, intern.name)
        internship.save
        internship
      }
      let(:params) { {id: internship.id, commit: "Remove"} }
    
      context "it does not work" do

        before do
          Internship.any_instance.should_receive(:delete_intern!).and_return(false)
        end

        it "does not delete the intern" do
          put :update, params
          expect(internship.reload.intern).not_to eql nil
        end

        it "shows an error flash" do
          put :update, params
          flash[:error].should_not be_blank
        end
      end

      context "it works" do
        it 'shows a success flash message' do
          put :update, params
          flash[:notice].should_not be_blank
        end

        it 'sets the intern_id to nil' do
          put :update, params
          expect(internship.reload.intern).to eql nil
        end
      end
    end

    context 'when user wants to assign intern' do


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
      @day = FactoryGirl.create(:day)
    end

    it "renders the new form" do
      get :new, :day_id => @day.id
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
