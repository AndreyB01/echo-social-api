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
        User.create!(@params)
      end
    end
  end
end