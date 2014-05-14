require 'spec_helper'

describe InternshipsController do

  describe "routing" do
    it 'routes to sign_up_form' do
      get('internships/4/sign_up_form').should route_to('internships#sign_up_form', id: '4')
    end

    it 'routes to edit_intern' do
      get('internships/4/edit_intern').should route_to('internships#edit_intern', id: '4')
    end

    it 'routes to update_intern' do
      get('internships/4/update_intern').should route_to('internships#update_intern', id: '4')
    end

  end
  
end