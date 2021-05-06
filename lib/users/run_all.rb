module Users 
  class RunAll 
    def initialize(users_quantity)
      @users_q = users_quantity
    end

    def call 
      users = create_users(@users_q)
      add_repayment_conditions(users)
      create_ranking(users)
      create_admin() if @admin 
    end

    private 

    def create_users(q)
      fresh_users = []
      q.times do |i|
        fresh_users << User.create!({
                        username: Faker::Internet.username + i.to_s,
                        email: Faker::Internet.email,
                        password: 'password1',
                        password_confirmation: 'password1'
                      })
      end
      fresh_users
    end

    def add_repayment_conditions(users)
      users.each do |creditor|
        WriteModels::RepaymentCondition.create!(
          {
            maturity_in_days: rand(5..10),
            creditor_id: creditor.id,
            currency_id: Currency.ids.sample
          }
        )
      end
    end

    def create_ranking(users)
      User.all.each do |user|
        WriteModels::DebtorsRanking.create!(debtor_id: user.id)
        WriteModels::CreditorsRanking.create!(creditor_id: user.id)
      end
    end

  end
end