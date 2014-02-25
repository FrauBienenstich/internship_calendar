require 'spec_helper'

describe "slots/index" do
  before(:each) do
    assign(:slots, [
      stub_model(Slot,
        :name => "Name"
      ),
      stub_model(Slot,
        :name => "Name"
      )
    ])
  end

  it "renders a list of slots" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
