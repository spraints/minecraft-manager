Rails.application.configure do
  MissionControl::Jobs.http_basic_auth_enabled = false
end
