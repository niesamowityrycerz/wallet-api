module Groups 
  class RegisterGroupService 
    def initialize(base_params, current_user)
      @base_params = base_params
      @current_user = current_user
    end

    def call
      params = prepare_params(@base_params)
      create_command(params)
    end

    private 

    def prepare_params(params)
      params.merge!({
        leader_id: @current_user.id,
        group_uid: SecureRandom.uuid
      })

    end

    def create_command(data)
      ::Groups::Commands::RegisterGroup.send(data)
    end
  end
end