class WarningsQuery
  def initialize(warnings, filters, pagination)
    @warnings = warnings
    @filters = filters
    @pagination = pagination 
  end

  def call
    if !@filters.nil?
      filter_by_username(@filters[:username]) if @filters[:username].present?
      filter_by_date(@filters[:sent_at]) if @filters[:sent_at].present?
      filter_by_type(@filters[:warning_type]) if @filters[:warnings_type].present?
      filter_by_points(@filters[:penalty_points]) if @filters[:penalty_points].present?
    end
    paginate(@pagination)
  end

  private 

  def paginate(info)
    # temporary 
    if info.nil?
      @warnings.page(1)
    else 
      @warnings.page(info[:page])
    end
  end

  def filter_by_username(name)
    user = User.find_by!(username: name)
    @warnings = @warnings.where("user_id = ?", user.id)
  end

  def filter_by_date(range)
    @warnings = @warnings.where("created_at <= ? AND created_at >= ?", range[:to], range[:from])
  end

  def filter_by_type(type)
    @warnings = @warnings.where("warning_type_name = ?", type)
  end

  def filter_by_points(range)
    @warnings = @warnings.where("penalty_points <= ? AND penalty_points >= ?", range[:max], range[:min])
  end
end