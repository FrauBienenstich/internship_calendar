require 'spec_helper'

describe InternshipsController do
  render_views

  describe 'POST create' do

    context "with valid attributes" do #why do invalid attributes not go into model?

      before do 
        @day = FactoryGirl.create(:day)

        @params = {

          host: {
            email: "susanne@dewein.de",
            name: "Susanne Dewein"

          },

          internship: {
            day_id: @day.id,
            description: "Test",
            start_time: @day.date + 4.hours,
            end_time: @day.date + 5.hours
          }
        }
      end

      context "new person " do

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

        it 'sends out email' do
          internship = double("my Internship").as_null_object
          Internship.stub(:new).and_return(internship)
          PersonMailer.any_instance.should_receive(:confirmation_mail).with(internship)
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

          host: {
            email: person.email,
            name: person.name
          },

          internship: {
            day_id: @day.id,
            description: "Test", 
            start_time: @day.date + 4.hours,
            end_time: @day.date + 5.hours
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

          host: {
            email: "susanne@dewein.de",
            name: "Susanne Dewein"
          },
          
          internship: {
            day_id: @day.id,
            description: "",
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

      it 'renders an error message and does not save' do
        expect do
          post :create, @params
        end.not_to change{ Internship.count }
        response.should redirect_to day_path(@day)
        flash[:error].should_not be_blank
      end
    end

    context "for a day in the past" do
      it "does not save a new internship" do
        @day = FactoryGirl.create(:day)
        @day.date = Date.today.prev_day

        @params = {

          host: {
            email: "susanne@dewein.de",
            name: "Susanne Dewein"

          },

          internship: {
            day_id: @day.id,
            description: "Test",
            start_time: @day.date - 5.hours,
            end_time: @day.date - 4.hours
          }
        }

        expect do
          post :create, @params
        end.not_to change{ Internship.count }
        response.should redirect_to day_path(@day)
        flash[:error].should_not be_blank
      end

    end
  end

  describe 'PUT update' do

    before do
      @internship = FactoryGirl.create(:internship)

      @params = {
          
          host: {
            email: @internship.host.email,
            name: @internship.host.name
          },

          id: @internship.id,

          internship: {
            day_id: @internship.day.id,
            description: "updated description",
            start_time: @internship.day.date + 4.hours,
            end_time: @internship.day.date + 5.hours
          }
        }

    end


    # Parameters: {"utf8"=>"✓", "authenticity_token"=>"gZBx+6Ybn5XicbBKwb9Uhtcks0fIloe84xB28Gp+Dow=", 

    #     "internship"=>{"day_id"=>"25", "description"=>"check die params", "start_time"=>"21/05/2014, 09:00", "end_time"=>"21/05/2014, 10:00"},

    #      "host"=>{"email"=>"susanne.dewein@gmail.com", "name"=>"sdgdxgv"}, 

    #"commit"=>"Update Internship", "id"=>"94"}

    context 'it works' do

      it 'does not add a new internship' do
        expect {
          put :update, @params
        }.not_to change{ Internship.count }
         expect(flash[:notice]).to eql 'Internship was successfully updated!'
      end

      it 'assigns the internship' do
        put :update, @params
        expect(assigns(:internship)).not_to eq nil
      end

      it 'redirects on html requests' do
        put :update, @params
        response.should redirect_to day_path(@internship.day)
      end

      it 'renders update javascript' do
        xhr :put, :update, @params
        response.should render_template :update
      end

      it "shows an error flash" do
        Internship.any_instance.should_receive(:update_attributes).and_return(false)
        put :update, @params
        flash[:error].should_not be_blank
      end
    end

  end

  describe 'PUT update_intern' do

    before do
      @internship = double("my internship")
      Internship.stub(:find_by).with(id: "12").and_return(@internship)

      @intern = double("my_intern")
      Internship.stub(:intern).and_return(@intern)

      @ical = double('ical')
      @internship.stub(:to_ical).and_return(@ical)

      @day = double('day')
      @mailer = double('mailer')
      @internship.stub(:day).and_return(@day)
      @day.stub(:date).and_return(Date.new(2050, 4, 21))

      PersonMailer.stub(:assign_intern_mail).and_return(@mailer)

      PersonMailer.stub(:confirmation_for_intern_mail).and_return(@mailer)

      @email = "susanne.dewein@gmail.com"
      @name = "Susanne Dewein"
    end

    context "when assigning an intern" do
      context "in case of success" do

        it 'adds an intern to an internship' do
          #@internship.stub(:intern).and_return(:false)
          @internship.should_receive(:assign_intern).with(@email, @name).and_return(true)
          @mailer.should_receive(:deliver).twice
          put :update_intern, id: 12, email: @email, name: @name
        end

        it 'redirects to day path' do
          @internship.stub(:assign_intern).and_return(true)
          @mailer.should_receive(:deliver).twice
          put :update_intern, id: 12, email: @email, name: @name
          response.should redirect_to day_path(@internship.day)
        end

        it 'sends out emails' do
          @internship.stub(:assign_intern).and_return(true)
          @mailer.should_receive(:deliver).twice
          PersonMailer.should_receive(:assign_intern_mail).with(@internship)
          put :update_intern, id: 12, email: @email, name: @name
        end

        it "shows a success flash" do
          @internship.stub(:assign_intern).and_return(true)
          @mailer.should_receive(:deliver).twice
          put :update_intern, id: 12, email: @email, name: @name
          flash[:notice].should_not be_blank
        end

        it 'updates an already existing intern' do

        end
      end

      context "in case of error" do

        before do
          @internship.stub(:errors).and_return(ActiveModel::Errors.new(@internship))
        end

        it "should not send an email" do
          @internship.stub(:assign_intern).and_return(false)
          @mailer.should_not_receive(:deliver)
          PersonMailer.should_not_receive(:assign_intern_mail).with(@internship)
          put :update_intern, id: 12, email: "", name: ""
        end

        it "shows an error flash" do
          @internship.stub(:assign_intern).and_return(false)
          put :update_intern, id: 12, email: "", name: ""
          flash[:error].should_not be_blank
        end
      end

      context "when the date is in the past" do
        before do
          @day.stub(:date).and_return(Date.new(1986, 4, 21))
        end

        it 'does not update the internship' do
          expect do
            put :update_intern, id: 12, email: @email, name: @name
          end.not_to change{ Internship.count }
          response.should redirect_to day_path(@day)
          flash[:error].should_not be_blank
        end

      end
    end
  end

  describe 'PUT update_intern version 2' do

    let(:internship) { 
      intern = FactoryGirl.create(:intern)
      internship = FactoryGirl.create(:internship) 
      internship.assign_intern(intern.email, intern.name)
      internship.save
      internship
    }

    before :each do
      internship
    end

    shared_examples "for updating interns" do
      it 'assigns the internship' do
        do_request
        expect(assigns(:internship)).not_to eq nil
      end

      it 'redirects on html requests' do
        do_request
        response.should redirect_to day_path(internship.day)
      end

      it 'renders update javascript' do
        do_request({}, true)
        response.should render_template :update
      end
      # render udpate.js bei xhr requests
    end

    def do_request(params = { }, ajax = false)
      params = params.reverse_merge({:id => internship.id, :name => "Horst", :email => "horst@horst.de"})
      if ajax
        xhr :put, :update_intern, params
      else
        put :update_intern, params
      end
    end


    context 'remove an intern' do
      include_examples "for updating interns"

      it "worked" do
        do_request(:commit => 'Remove')
        expect(internship.reload.intern).to eql nil
      end

      it "didnt work" do
        Internship.any_instance.should_receive(:delete_intern!).and_return(false)
        do_request(:commit => 'Remove')
        expect(flash[:error]).to eql 'Did not work'
      end
    end

    context 'add an intern' do



      context 'that exists' do
        include_examples "for updating interns"

        it 'reuses existing people' do
          intern = FactoryGirl.create(:intern)
          expect {
            do_request(:email => intern.email, :name => intern.name)
            expect(internship.reload.intern).not_to eql nil
          }.not_to change {Person.count}
        end
      end

      context 'that does not exist' do
        include_examples "for updating interns"

        it 'creates a new intern' do
          expect {
            do_request(:email => "new@domain.com", :name => "Neui Neumann")
            expect(internship.reload.intern).not_to eql nil
          }.to change {Person.count}.by(1)
        end
      end

      it "didnt work" do
        Internship.any_instance.should_receive(:assign_intern).and_return(false)
        do_request
        flash[:error].should match /Your application as an intern failed!/
      end
    end
  end

  describe 'PUT update_intern without mocks and stubs' do
    context 'if user wants to delete intern' do

      let(:internship) { 
        intern = FactoryGirl.create(:intern)
        internship = FactoryGirl.create(:internship) 
        internship.assign_intern(intern.email, intern.name)
        internship.save
        internship
      }
      let(:params) { {id: internship.id, commit: "Remove"} }

      context 'deletion successful' do
        context "it works" do
          it 'shows a success flash message' do
            put :update_intern, params
            flash[:notice].should_not be_blank
          end

          it 'sets the intern_id to nil' do
            put :update_intern, params
            expect(internship.reload.intern).to eql nil
          end
        end
      end

      context 'deleting does not work' do
        before do
          Internship.any_instance.should_receive(:delete_intern!).and_return(false)
        end

        it "does not delete the intern" do
          put :update_intern, params
          expect(internship.reload.intern).not_to eql nil
        end

        it "shows an error flash" do
          put :update_intern, params
          flash[:error].should_not be_blank
        end
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
      expect(response).to redirect_to day_path(internship.slot.day)
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
      expect { get :edit }.to render_template :sign_up_form
    end
  end

  describe 'GET edit' do

    before do
      @internship = FactoryGirl.create(:internship)
    end

    it "renders the edit form" do
      get :edit, :id => @internship.id
      expect { get :edit }.to_not render_template(layout: "application")
      expect { get :edit }.to render_template :edit
    end
  end

  describe 'GET edit_intern' do
    before do
      @internship = FactoryGirl.create(:internship)
      @internship.create_intern( FactoryGirl.attributes_for(:intern) ) # WICHTIG!!!
      @internship.save
    end

    it "renders the edit_intern form" do
      get :edit_intern, :id => @internship.id
      expect { get :edit }.to_not render_template(layout: "application")
      expect { get :edit }.to render_template :edit_intern
    end
  end

end
