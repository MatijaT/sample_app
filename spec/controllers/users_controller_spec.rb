require 'spec_helper'

describe UsersController do
render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "treba da ima pravi naslov" do

	it "treba da prodje" do
		get 'new'
		response.should have_selector("title", 					:content=>"Sign up")
	end
  end
end
