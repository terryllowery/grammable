FactoryBot.define do
	factory :user do
		sequence :email do |n|
			"dummyemail#{n}@email.com"
		end
		password 'secretPassword#1'
		password_confirmation 'secretPassword#1'
	end
end
