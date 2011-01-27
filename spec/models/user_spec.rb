require 'spec_helper'

describe User do

before(:each) do
@attr = {:name=>"ha", :email=>"ha@a.com"}
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
end
