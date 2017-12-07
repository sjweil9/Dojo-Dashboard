class Student < ActiveRecord::Base
    EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
    validates :first_name, :last_name, length: { in: 2..25, message: 'Name fields must be between 2 and 25 characters' }
    validates :email, format: { with: EMAIL_REGEX, message: 'Not a valid email address' }
    belongs_to :dojo
end
