module Auth
  class LogoutAllService
    def self.call(user:)
      new(user).call
    end

    def initialize(user)
      @user = user
    end

    def call
      user.user_sessions.active.update_all(
        revoked_at: Time.current,
        updated_at: Time.current
      )
    end

    private

    attr_reader :user
  end
end