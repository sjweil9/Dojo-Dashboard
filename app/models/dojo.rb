class Dojo < ActiveRecord::Base
    STREET_REGEX = /\d+\s[a-zA-Z\d]+/i
    validates :branch, :street, :city, length: { in: 2..45 }
    validates :street, format: { with: STREET_REGEX, message: "is not a valid Address" }
    validates :state, length: { is: 2 }
    has_many :students
end
