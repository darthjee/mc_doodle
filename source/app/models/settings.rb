# frozen_string_literal: true

class Settings
  extend Sinclair::EnvSettable

  settings_prefix 'MC_DOODLE'

  with_settings(
    :password_salt,
    :token_salt,
    hex_code_size: 16,
    session_period: 2.days,
    cache_age: 10.seconds,
    pagination: 10
  )
end
