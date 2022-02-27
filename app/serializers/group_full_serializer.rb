class GroupFullSerializer < ActiveModel::Serializer
  attributes :id, :started, :name, :code, :url, :description, :members_number, :admin_id, :users, :category_id

  def users
    object.users.map do |user|
      UserSerializer.new(user)
    end
  end
end

