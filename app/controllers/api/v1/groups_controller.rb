class Api::V1::GroupsController < ApplicationController
  def index
    user = User.find_by(id: params[:user_id]) if params[:user_id]
    if user
      joinned_groups = user.groups
      other_groups = Group.all.select{ |group| (joinned_groups.include? group) == false }
      joinned_groups = joinned_groups.order('created_at DESC')
      other_groups = other_groups.sort { |a, b| b.created_at <=> a.created_at }
      render json: {
        status: true,
        joined: joinned_groups,
        others: other_groups,
      }, 
      status: :ok
    else
      render json: {messeage: "Couldn't find user by id = #{params[:user_id]}"}, status: :not_found
    end

   
  end

  def join
    user = User.find_by(id: params[:user_id])
    group = Group.find_by(code: params[:code])
      if user
        if group
          if group.users.include? user
            render json: {message: "You already join this group"}, status: :bad_request
          else  
            members_number = group.users.count
            group.users << user
            members_number2 = group.users.count
            if members_number2 - members_number == 1
              group.update(members_number: members_number2)
              render json: group, status: :ok
            else
              render json: group.errors, status: :bad_request
            end
          end
        else
          render json: {messeage: "Couldn't find group by code = #{params[:code]}"}, status: :not_found
        end
      else
        render json: {messeage: "Couldn't find user by id = #{params[:user_id]}"}, status: :not_found
      end
  end

  def create 
    user = User.find_by(id: params[:user_id])
    if user
      group = user.groups.new(group_params)
      default_url = "https://meet.jit.si/"
      group.members_number = 0
      group.code = random_code
      group.url = default_url + group.code

      if group.save
        render json: group, status: :created
      else
        render json: group.errors, status: :unprocessable_entity
      end
    else
      render json: {messeage: "Couldn't find user by id = #{params[:user_id]}"}, status: :not_found
    end
  end

  def out_group
    user = User.find_by(id: params[:user_id]) if params[:user_id] 
    group = Group.find_by(id: params[:room_id]) if params[:room_id]
    if user
      if group
        if (group.users.include? user) == false
          render json: {message: "Couldn't find user in room"}, status: :not_found
        else  
          members_number = group.users.count
          group.users.destroy(user)
          members_number2 = group.users.count
          if members_number2 - members_number == 1
            group.update(members_number: members_number2)
            render json: group, status: :ok
          else
            render json: group.errors, status: :bad_request
          end
        end
      else
        render json: {messeage: "Couldn't find room by id = #{params[:room_id]}"}, status: :not_found
      end
    else
      render json: {messeage: "Couldn't find user by id = #{params[:user_id]}"}, status: :not_found
    end
  end


  def update
   
  end

  def delete
  end

  def random_code
    codes = Group.all.pluck(:code)
    random_string = ('a'..'z').to_a.shuffle.first(8).join
    random_code = random_string.upcase
    while(codes.include? random_code) do
      random_string = ('a'..'z').to_a.shuffle.first(8).join
      random_code = random_string.upcase
    end
    return random_code
  end

  private
    def group_params
      params.permit(:name, :description)
    end
end