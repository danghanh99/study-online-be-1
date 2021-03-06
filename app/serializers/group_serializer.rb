class GroupSerializer < ActiveModel::Serializer
  attributes :id, :started, :name, :code, :url, :description, :members_number, :admin_id, :category, :list_black_members

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
end
