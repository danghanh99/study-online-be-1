class GroupFullSerializer < ActiveModel::Serializer
  attributes :id, :started, :name, :code, :url, :description, :members_number, :admin_id, :users, :category, :list_black_members

  def category
    Category.find_by(id: object.category_id) if object.category_id
  end

  def list_black_members
    list = []
    object.black_members.each do |index|
      user = User.find_by(id: index) if index
      list.push(UserSerializer.new(user)) if user
    end
    list
  end

  def users
    list = []
    object.users.map do |user|
      list.push(UserSerializer.new(user)) if object.admin_id != user.id
    end
    list
  end
end

