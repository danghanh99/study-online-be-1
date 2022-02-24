class GroupFullSerializer < ActiveModel::Serializer
  attributes :id, :started, :name, :code, :url, :description, :members_number, :admin_id, :users

  def users
    object.users.map do |user|
      UserSerializer.new(user)
    end
  end
end

