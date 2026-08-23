class Message < ApplicationRecord
  def sent_label
    return "" unless sent_at

    time = sent_at.localtime
    clock = time.strftime("%-l:%M %p")

    case time.to_date
    when Date.current
      "Today at #{clock}"
    when Date.current - 1
      "Yesterday at #{clock}"
    else
      "#{time.strftime("%b %-d, %Y")} at #{clock}"
    end
  end
end
