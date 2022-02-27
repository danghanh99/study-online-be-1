class UserFullSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :password, :gender, :job, :owner_groups, :joined_groups

  def owner_groups
    # Group.all.select{|group| (group.users.include? object == true) && group.admin_id == object.id}
    object.groups.select{ |group| group.admin_id == object.id }
  end

  def job
    Job.find_by(id: object.job_id) if object.job_id
  end

  def joined_groups
    # Group.all.select{|group| (group.users.include? object == true) && group.admin_id != object.id}
    object.groups.select{ |group| group.admin_id != object.id }
  end
end
