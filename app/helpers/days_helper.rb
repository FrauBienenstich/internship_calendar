module DaysHelper

  def remaining_time_in_words(day)
    return "Invalid time" unless day.kind_of? Day
    rel_date = distance_of_time_in_words_to_now(day.date)
    now = Date.today
    if day.date < now
      rel_date = rel_date + " ago"
    elsif day.date > now
      rel_date = rel_date + " remaining"
    else
      rel_date = "Today!"
    end
    rel_date
  end

  def relative_date_in_words(day)
    return "Invalid time" unless day.kind_of? Day
    rel_date = distance_of_time_in_words_to_now(day.date)
    now = Date.today
    if day.date < now
      rel_date = rel_date + " ago"
    elsif day.date > now
      rel_date = "in " + rel_date
    else
      rel_date = "Today!"
    end
    rel_date
  end

  def percent(day)
    cnt = day.internships.count
    percent = (cnt > 0) ? (day.occupied_internships.to_f / cnt.to_f) * 100 : 0
  end
end
