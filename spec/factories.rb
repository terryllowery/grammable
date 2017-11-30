FactoryBot.define do
	factory :user do
		sequence :email do |n|
			"dummyemail#{n}@email.com"
		end
		password 'secretPassword#1'
		password_confirmation 'secretPassword#1'
	end

	factory :gram do
		message "Hello"
		picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'picture.png'), 'image/png')}
		association :user
	end

end

