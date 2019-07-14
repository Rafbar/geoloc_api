json.partial! 'api/v1/shared/user', user: @current_user
json.token @token
json.exp @time.strftime("%m-%d-%Y %H:%M")
