ready = ->
  $('#usersTable').dataTable
    sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#usersTable').data('source')

	changeUserRole = ()->
		$('.user-role').on 'change', ()->
			select_id = $(this).attr('id')
			role = $(this).val()
			user_id = select_id.split('_').reverse()[0]
			console.log 'hello'
			url = "/users/#{user_id}/change_user_role"

			$.ajax
				url: url
				type: 'PUT'
				data: { user: { role: role } }
				success: ()->
					alert('Updated')
					
	changeUserRole()

$(document).ready(ready)
$(document).on('page:load', ready)
    