# frozen_string_literal: true

module McDoodle
  class Exception < StandardError
    class LoginFailed  < McDoodle::Exception; end
    class Unauthorized < McDoodle::Exception; end
    class NotLogged    < McDoodle::Exception; end
  end
end
