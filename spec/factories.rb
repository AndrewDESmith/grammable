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
    # The association line means that the gram factory will automatically connect the user_id of this model (:gram) to a user created from a :user factory.
    association :user
  end
end
