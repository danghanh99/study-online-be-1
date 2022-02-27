class GroupSerializer < ActiveModel::Serializer
  attributes :id, :started, :name, :code, :url, :description, :members_number, :admin_id, :category

  def category
    Category.find_by(id: object.category_id) if object.category_id
  end
end
