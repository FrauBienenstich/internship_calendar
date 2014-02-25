require 'spec_helper'

describe "slots/show" do
  before(:each) do
    @slot = assign(:slot, stub_model(Slot,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
