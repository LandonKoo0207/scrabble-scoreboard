FactoryBot.define do
  emails = ["landonk1@gmail.com", "johns.s@kmart.com"]
  passwords_valid = ["kpk47503", "dhfle111", "ncdke12", "123842n"]
  passwords_invalid = ["111", "3", "abcd", "dddd", "dkjf"]

  factory :random_valid_user, class: User do
    email { emails.sample }
    password { passwords_valid.sample }
  end

  factory :random_invalid_user, class: User do
    email { emails.sample }
    password { passwords_invalid.sample }
  end
end