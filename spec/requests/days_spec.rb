require 'spec_helper'

describe "Days" do
  describe "GET /" do
    it "takes the user to the day or start page" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get '/'
      response.status.should be(200)
    end

    it "shows time slots" do


    end

    it "shows names of hosts who entered their names" do
      Person.create!(:name => "Host" )
      get '/'
      expect(response.body).to include "Host"
      #response.body.should include("Host")

    end
  end


end
