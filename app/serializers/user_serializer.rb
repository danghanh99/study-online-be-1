class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :password, :gender, :job, :created_at, :updated_at
end
