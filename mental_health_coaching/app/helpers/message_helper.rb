module MessageHelper
  def since_created(created)
    past_time = (Time.zone.now - created) /60 /60
    if past_time >= 1
      result = past_time.round
      result = result.to_s + "h"
    elsif past_time >= 24
      result = past_time / 24
      result = result.round
      result = result.to_s + " days"
    else
      result = (past_time * 60).round
      result = result.to_s + " min"
    end

    result
  end
end
