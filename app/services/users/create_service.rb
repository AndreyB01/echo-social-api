module Users
  class CreateService
    def self.call(params)
      new(params).call
    end

    def initialize(params)
      @params = params
    end

    def call
      User.transaction do
        user = User.create!(@params)

        token_data =
          Auth::EmailConfirmationTokenGenerator.call(
            user: user
          )

        UserMailer
          .confirmation_email(
            user,
            token_data[:raw_token]
          )
          .deliver_later

        user
      end
    end

    private

    attr_reader :params
  end
end