class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :password, :gender, :job, :created_at, :updated_at
  def job
    Job.find_by(id: object.job_id) id object.job_id
  end
end
