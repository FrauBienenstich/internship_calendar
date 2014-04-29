require 'spec_helper'

describe InternshipsController do

  describe "routing" do
    it 'routes to sign_up_form' do
      get('internships/4/sign_up_form').should route_to('internships#sign_up_form', id: '4')
    end
  end
  
end