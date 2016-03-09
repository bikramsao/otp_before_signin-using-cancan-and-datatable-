class UserDatatable 
  include AjaxDatatablesRails::Extensions::WillPaginate
  delegate :params, :link_to, :user_path, :select_tag, :options_for_select, :edit_user_path, :can?,
           :current_user,:button_to,:user_unblock_path, :user_block_path,
           :user_confirm_path, to: :@view

  
  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: User.count,
      iTotalDisplayRecords: users.total_entries,
      aaData: data
    }
  end

private

  def data
    users.map do |user|
      [
        user.id,
        link_to(user.name, user_path(user), remote: true , 
        data: { toggle: "modal", target: '#modal-window' }),
        user.email,
        
        if can? :update, User
          select_tag 'role', options_for_select(['visitor','admin','moderator'], user.role),
          { class: 'user-role', id: "user_role_#{user.id}"}
        end, 

        if can? :update, User
          link_to('Edit',edit_user_path(user),class: "btn btn-info")
        end,

        if can? :destroy, user and user!=current_user
          link_to('destroy',user , method: :delete , data: {confirm: "Sure to destroy"} ,
          :remote => true , :class => 'btn btn-danger delete_user')
        end,

        if user.activated == true
          'confirmed'
        else
          if can? :update, User
            button_to('Confirm', user_confirm_path(user.id), method: :put , class: "btn btn-info")
          else
            'Unconfirmed'
          end
        end,

        if can? :update, User and user!=current_user
          if user.blocked == true
            button_to('Unblock', user_unblock_path(user.id), method: :put , class: "btn btn-warning")
          else
            button_to('Block', user_block_path(user.id), method: :put , class: "btn btn-danger")
          end
        end    
      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.order("#{sort_column} #{sort_direction}")
    users = users.page(page).per_page(per_page)
    if params[:sSearch].present?
      users = users.where("name like :search or 
                           email like :search or
                           role like :search", 
                           search: "%#{params[:sSearch]}%")
    end
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[id name email]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
