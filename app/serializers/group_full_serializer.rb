class GroupFullSerializer < ActiveModel::Serializer
  attributes :id, :started, :name, :code, :url, :description, :members_number, :admin_id, :users, :category

  def category
    Category.find_by(id: object.category_id) if object.category_id
  end

  def users
    list = []
    object.users.map do |user|
      list.push(UserSerializer.new(user)) if object.id == user.id
    end
    list
  end
end

