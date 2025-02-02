module Groups 
  class RegisterGroup 
    def initialize(group_q)
      @group_q = group_q
    end

    def call
      grab_users(@group_q)
      # TO DO
      # adding friends in the way like this does not work
      # however, in console and through requests it works
      #make_friendships(@friends) 
      params = prepare_data(@group_q, @friends)
      register_group(params)
    end

    private 

    def grab_users(leader_q)
      leaders = User.ids.sample(20)
      available_users = User.ids - leaders 
      @friends = []
      leaders.each do |leader_id|
        @friends << {
          leader_id: leader_id,
          invited_users_ids: available_users.sample(rand(2..4))
        }
      end
    end 

    def make_friendships(group_users)
      group_users.each do |group|
        leader = User.find_by!(id: group[:leader_id])
        invited_users = group[:invited_users_ids].collect { |id| User.find_by!(id: id)}
        invited_users.each do |user|
          user.friend_request(leader)
          leader.accept_request(user)
        end
      end
    end


    def prepare_data(quantity, users)
      data = []
      quantity.times do |i|
        group_members = users[i]
        data << {
          group_uid: SecureRandom.uuid,
          leader_id: group_members[:leader_id],
          invited_users: group_members[:invited_users_ids],
          group_name: "Group_#{Faker::Cannabis.strain}",
          from: Date.today - rand(1..7),
          to: Date.today + rand(1..7)
        }
      end
      data 
    end

    def register_group(group_data)
      group_data.each do |data|
        Rails.configuration.command_bus.call(
          Groups::Commands::RegisterGroup.send(data)
        )
      end
    end
  end
end