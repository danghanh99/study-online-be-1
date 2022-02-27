class Api::V1::GroupsController < ApplicationController
  def index
    user = User.find_by(id: params[:user_id]) if params[:user_id]
    if user
      joinned_groups = user.groups
      other_groups = Group.all.select{ |group| (joinned_groups.include? group) == false }
      joinned_groups = joinned_groups.order('created_at DESC')

      admin_groups = joinned_groups.select{ |group| group.admin_id == user.id } if joinned_groups
      joinned_groups = joinned_groups.select{ |group| (admin_groups.include? group) == false } if admin_groups

      other_groups = other_groups.sort { |a, b| b.created_at <=> a.created_at }
      render json: {
        status: true,
        joined: {admin: admin_groups, others: joinned_groups},
        others: other_groups,
      }, 
      status: :ok
    else
      render json: {messeage: "Couldn't find user"}, status: :not_found
    end
  end

  def revert_member
    admin = User.find_by(id: params[:admin_id]) if params[:admin_id] 
    member = User.find_by(id: params[:member_id]) if params[:member_id] 
    group = Group.find_by(id: params[:room_id]) if params[:room_id]
    if admin
      if member
        if group
          if (group.black_members.include? member.id) == true
            if  (group.users.include? admin) == true
              if group.admin_id == admin.id
                if admin.id == member.id
                  render json: {messeage: "Duplicate user"}, status: :bad_request
                else
                  group.black_members.delete(member.id)
                  if group.save
                    render json: group, serializer: GroupFullSerializer, status: :ok
                  else
                    render json: group.errors, status: :bad_request
                  end
                end
              else
                render json: {messeage: "Permission deny"}, status: :not_found
              end
            else
              render json: {messeage: "Couldn't find admin in room"}, status: :not_found
            end 
          else
            render json: {messeage: "Couldn't find member in room's black list"}, status: :not_found
          end
        else
          render json: {messeage: "Couldn't find room"}, status: :not_found
        end
      else
        render json: {messeage: "Couldn't find member"}, status: :not_found
      end
    else
      render json: {messeage: "Couldn't find admin"}, status: :not_found
    end
  end

  def update
    group =  Group.find_by(id: params[:id]) if params[:id]
    user =  User.find_by(id: params[:user_id]) if params[:user_id]
    category =  Category.find_by(id: params[:category_id]) if params[:category_id]
    if group
      if user
        if category
          if group.admin_id == user.id
            group.update(group_params)
            if group.save 
              render json: group, serializer: GroupFullSerializer,
              status: :ok
            else
              render json: group.errors, status: :bad_request
            end
            
          else
            render json: {messeage: "Permission deny"}, status: :bad_request
          end
        else
          render json: {messeage: "Couldn't find category"}, status: :not_found
        end
      else
        render json: {messeage: "Couldn't find user"}, status: :not_found
      end
    else
      render json: {messeage: "Couldn't find room "}, status: :not_found
    end
  end

  def show
    group =  Group.find_by(id: params[:id]) if params[:id]
    user =  User.find_by(id: params[:user_id]) if params[:user_id]
    if group
      if user
        if group.admin_id == user.id
          render json: group, serializer: GroupFullSerializer,
          status: :ok
        else
          render json: {messeage: "Permission deny"}, status: :bad_request
        end
      else
        render json: {messeage: "Couldn't find user"}, status: :not_found
      end
    else
      render json: {messeage: "Couldn't find room "}, status: :not_found
    end
  end

  def join
    user = User.find_by(id: params[:user_id])
    group = Group.find_by(code: params[:code])
    group = Group.find_by(id: params[:room_id]) unless group
      if user
        if group
          if (group.black_members.include? user.id) == true
            render json: {messeage: "You are in room's black list, contact admin..."}, status: :bad_request
          else
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
          end
        else
          render json: {messeage: "Couldn't find group"}, status: :not_found
        end
      else
        render json: {messeage: "Couldn't find user by id = #{params[:user_id]}"}, status: :not_found
      end
  end

  def create 
    user = User.find_by(id: params[:user_id])
    if params[:category_id]
      category = Category.find_by(id: params[:category_id])
      if category
        if user
          group = user.groups.new(group_params)
          default_url = "https://meet.jit.si/"
          group.members_number = 0
          group.code = group.random_code
          group.url = default_url + group.code
          group.admin_id = user.id
          group.category_id = category.id
          if group.save
            user.groups << group
            user.save
            render json: group, status: :created
          else
            render json: group.errors, status: :unprocessable_entity
          end
        else
          render json: {messeage: "Couldn't find user by id = #{params[:user_id]}"}, status: :not_found
        end
      else
        render json: {messeage: "Couldn't find category"}, status: :not_found
      end
    else
      if user
        group = user.groups.new(group_params)
        default_url = "https://meet.jit.si/"
        group.members_number = 0
        group.code = group.random_code
        group.url = default_url + group.code
        group.admin_id = user.id
        if group.save
          user.groups << group
          render json: group, status: :created
        else
          render json: group.errors, status: :unprocessable_entity
        end
      else
        render json: {messeage: "Couldn't find user by id = #{params[:user_id]}"}, status: :not_found
      end
    end
  end

  def out_group
    user = User.find_by(id: params[:user_id]) if params[:user_id] 
    group = Group.find_by(id: params[:room_id]) if params[:room_id]
    if user
      if group
        if group.admin_id == user.id
          group.users.destroy_all
          group.destroy!
          # user.groups.destroy(group)
          render json: {message: "success"}, status: :ok
        else
          if (group.users.include? user) == false
            render json: {message: "Couldn't find user in room"}, status: :not_found
          else  
            members_number = group.users.count
            group.users.destroy(user)
            members_number2 = group.users.count
            if members_number - members_number2 == 1
              group.update(members_number: members_number2)
              render json: group, serializer: GroupFullSerializer, status: :ok
            else
              render json: group.errors, status: :bad_request
            end
          end
        end
      else
        render json: {messeage: "Couldn't find room by id = #{params[:room_id]}"}, status: :not_found
      end
    else
      render json: {messeage: "Couldn't find user by id = #{params[:user_id]}"}, status: :not_found
    end
  end

  def remove_member
    admin = User.find_by(id: params[:admin_id]) if params[:admin_id] 
    member = User.find_by(id: params[:member_id]) if params[:member_id] 
    group = Group.find_by(id: params[:room_id]) if params[:room_id]
    if admin
      if member
        if group
          if (group.users.include? member) == true
            if  (group.users.include? admin) == true
              if group.admin_id == admin.id
                if admin.id == member.id
                  render json: {messeage: "Duplicate user"}, status: :bad_request
                else
                  members_number = group.users.count
                  group.users.destroy(member)
                  members_number2 = group.users.count
                  if members_number - members_number2 == 1
                    group.update(members_number: members_number2)
                    group.black_members.push(member.id)
                    if group.save
                      render json: group, serializer: GroupFullSerializer, status: :ok
                    else
                      render json: group.errors, status: :bad_request
                    end
                  else
                    render json: "Cloldn't remove, update number member", status: :bad_request
                  end
                end
              else
                render json: {messeage: "Permission deny"}, status: :not_found
              end
            else
              render json: {messeage: "Couldn't find admin in room"}, status: :not_found
            end 
          else
            render json: {messeage: "Couldn't find member in room"}, status: :not_found
          end
        else
          render json: {messeage: "Couldn't find room"}, status: :not_found
        end
      else
        render json: {messeage: "Couldn't find member"}, status: :not_found
      end
    else
      render json: {messeage: "Couldn't find admin"}, status: :not_found
    end
  end

  def start
    group =  Group.find_by(id: params[:room_id]) if params[:room_id]
    user = User.find_by(id: params[:user_id])
    if group
      if user
        if group.admin_id == user.id
          group.update!(started: true)
          render json: group, serializer: GroupFullSerializer,
          status: :ok
        else
          if group.started == true
            render json: {message: "join meeting success"}, status: :ok
          else
            render json: {message: "Waiting host start meeting..."}, status: :forbidden
          end
        end
      else
        render json: {messeage: "Couldn't find user by id = #{params[:user_id]}"}, status: :not_found
      end
    else
      render json: {messeage: "Couldn't find room by id = #{params[:room_id]}"}, status: :not_found
    end
  end

  def close
    group =  Group.find_by(id: params[:room_id]) if params[:room_id]
    user = User.find_by(id: params[:user_id])
    if group
      if user
        if (group.users.include? user) == true
          if group.started == true
            if group.admin_id == user.id
              group.update!(started: false)
              render json: group, serializer: GroupFullSerializer,
              status: :ok
            else
              render json: group, serializer: GroupFullSerializer, message: "close meeting success", status: :ok
            end
          else
            render json: {message: "Waiting host start meeting..."}, status: :bad_request
          end
        else
          render json: {message: "Couldn't find user in group"}, status: :not_found
        end
        
      else
        render json: {messeage: "Couldn't find user by id = #{params[:user_id]}"}, status: :not_found
      end
    else
      render json: {messeage: "Couldn't find room by id = #{params[:room_id]}"}, status: :not_found
  end
  end

  def delete_group
    user = User.find_by(id: params[:user_id]) if params[:user_id]
    group = Group.find_by(id: params[:room_id])  if params[:room_id]
      if user
        if group
          if group.admin_id != user.id
            render json: {message: "Permission denied"}, status: :forbidden
          else  
            group.users.destroy_all
            group.destroy!
            render json: {messeage: "Delete group success"}, status: :ok
          end
        else
          render json: {messeage: "Couldn't find group"}, status: :not_found
        end
      else
        render json: {messeage: "Couldn't find user by id = #{params[:user_id]}"}, status: :not_found
      end
  end

  

  private
    def group_params
      params.permit(:name, :description, :category_id)
    end
end