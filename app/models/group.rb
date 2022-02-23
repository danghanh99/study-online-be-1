class Group < ApplicationRecord
  has_and_belongs_to_many :users

  def random_code
    codes = Group.all.pluck(:code)
    random_string = ('a'..'z').to_a.shuffle.first(8).join
    random_code = random_string.upcase
    while(codes.include? random_code) do
      random_string = ('a'..'z').to_a.shuffle.first(8).join
      random_code = random_string.upcase
    end
    return random_code
  end
end
