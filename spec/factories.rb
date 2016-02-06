FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"
  end

  factory :gram do
    message "hello"
    # Inside our factories.rb file, we need to give the fixture_file_upload method the full path of the file where it lives in our computer.
    picture { fixture_file_upload(Rails.root.join("spec", "fixtures", "picture.jpg"), "image/jpg") }

    # The association line means that the gram factory will automatically connect the user_id of this model (:gram) to a user created from a :user factory.
    association :user
  end
end
