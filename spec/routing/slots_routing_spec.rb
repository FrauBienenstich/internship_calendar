require "spec_helper"

describe SlotsController do
  describe "routing" do

    it "routes to #index" do
      get("/slots").should route_to("slots#index")
    end

    it "routes to #new" do
      get("/slots/new").should route_to("slots#new")
    end

    it "routes to #show" do
      get("/slots/1").should route_to("slots#show", :id => "1")
    end

    it "routes to #edit" do
      get("/slots/1/edit").should route_to("slots#edit", :id => "1")
    end

    it "routes to #create" do
      post("/slots").should route_to("slots#create")
    end

    it "routes to #update" do
      put("/slots/1").should route_to("slots#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/slots/1").should route_to("slots#destroy", :id => "1")
    end

  end
end
