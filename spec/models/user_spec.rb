require 'spec_helper'

describe User do

before(:each) do
@attr = {:name=>"ha", :email=>"ha@a.com", :password=>"blabla", :password_confirmation=>"blabla"}
end

it "treba da prodje sa ispravnim imenom" do
	User.create!(@attr)
end

it "treba da ime ne bude prazno" do
	bezimeni = User.new(@attr.merge(:name=>""))
	bezimeni.should_not be_valid
end

it "treba da email ne bude prazno" do
	bezmaila = User.new(@attr.merge(:email=>""))
	bezmaila.should_not be_valid
end

it "ako je ime predugacko ne treba da prodje" do
	duuugo="a"*51
	dugoime = User.new(@attr.merge(:name=>duuugo))
	dugoime.should_not be_valid
end 

it "treba da prihvati regularnu email adresu" do
	adrese = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
	adrese.each do |a|
	dobar_mail = User.new(@attr.merge(:email=>a))
	dobar_mail.should be_valid
	end
end

it "ne treba da prihvati neregularnu email adresu" do
	adrese = %w[user@foo,com user_at_foo.org example.user@foo.]
	adrese.each do |a|
	los_mail = User.new(@attr.merge(:email=>a))
	los_mail.should_not be_valid
	end
end

it "treba da odbije duplikat emaila" do
	User.create!(@attr)
	user_with_duplicate_email=User.new(@attr)
	user_with_duplicate_email.should_not be_valid
end

it "treba da odbije email sa istim upcase" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

describe "password validations" do

	it "potreban je password" do
	User.new(@attr.merge(:password=>"",:password_confirmation=>"")).should_not 	be_valid
	end

	it "treba da se poklapa confirmation" do
	User.new(@attr.merge(:password_confirmation=>"invalid")).should_not be_valid
	end

	it "treba da odbije prekratke passworde" do
	kratki = "a"*5
	User.new(@attr.merge(:password=>kratki, 	:password_confirmation=>kratki)).should_not be_valid
	end

	it "treba da odbije preduge passworde" do
	dugi = "a"*41
	User.new(@attr.merge(:password=>dugi, 	:password_confirmation=>dugi)).should_not be_valid
	end

end

describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
	
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end 
    end

    describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
end

end
