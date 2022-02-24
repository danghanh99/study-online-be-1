class GroupSerializer < ActiveModel::Serializer
  attributes :id, :started, :name, :code, :url, :description, :members_number, :admin_id
end
