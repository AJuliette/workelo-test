require 'json'
require 'active_support/time'
require 'pry'

class Main
  def self.call
    duration = 2
  
    busy_slots_1 = get_busy_slots('./input_andy.json')
    busy_slots_2 =  get_busy_slots('./input_sandra.json')

    busy_hours_1 = busy_hours(busy_slots_1)
    busy_hours_2 = busy_hours(busy_slots_2)

    start_day = start_day(busy_slots_1, busy_slots_2)
    end_day = end_day(start_day)

    calendar_of_hours_of_the_week = calendar_of_hours_of_the_week(start_day, end_day)

    unoccupied_hours_1 = unoccupied_hours(busy_hours_1, calendar_of_hours_of_the_week)
    unoccupied_hours_2 = unoccupied_hours(busy_hours_2, calendar_of_hours_of_the_week)

    agenda_of_the_week_1 = agenda_of_the_week(busy_hours_1, unoccupied_hours_1)
    agenda_of_the_week_2 = agenda_of_the_week(busy_hours_2, unoccupied_hours_2)

    agenda_by_day_1 = group_by_day(agenda_of_the_week_1)
    agenda_by_day_2 = group_by_day(agenda_of_the_week_2)

    matching_hours_for_meeting = matching_hours_for_meeting(agenda_by_day_1, agenda_by_day_2, duration)
    
    output = format_data_for_output(matching_hours_for_meeting, duration)
    return_free_slots_for_meetings(output)
  end

  def self.get_busy_slots(file_path)
    file = File.read(file_path)
    JSON.parse(file)
  end

  def self.start_day(busy_slots_1, busy_slots_2)
    busy_slots = busy_slots_1 + busy_slots_2
    busy_slots.sort { |a,b| a["start"] <=> b["start"] }
    date = Date.parse(busy_slots.first["start"])
    hour = Time.parse("09:00:00").seconds_since_midnight.seconds
    date.to_datetime + hour
  end

  def self.end_day(start_day)
    date = start_day + 4.day
    hour = Time.parse("09:00:00").seconds_since_midnight.seconds
    date + hour
  end

  def self.busy_hours(busy_slots)
    busy_slots.flat_map do |busy_slot|
      (DateTime.parse(busy_slot["start"]).to_datetime.to_i ... DateTime.parse(busy_slot["end"]).to_datetime.to_i).step(1.hour).map do |datetime|
        Time.at(datetime).utc
      end
    end
  end

  def self.calendar_of_hours_of_the_week(start_day, end_day)
    (start_day.to_i ... end_day.to_i).step(1.day).each_with_object([]) do |day, array|
      beginning_of_day = Time.at(day).utc
      end_of_day = beginning_of_day + Time.parse("09:00:00").seconds_since_midnight.seconds
      (beginning_of_day.to_i ... end_of_day.to_i).step(1.hour).map do |hour|
        array << Time.at(hour).utc
      end
    end
  end

  def self.unoccupied_hours(busy_slots, calendar_of_hours_of_the_week)
    calendar_of_hours_of_the_week - busy_slots
  end

  def self.agenda_of_the_week(busy_hours, unoccupied_hours)
    busy_hours_noted = busy_hours.map { |busy_hour| { "datetime" => busy_hour, "busy" => 1 } }
    unoccupied_hours_noted = unoccupied_hours.map { |unoccupied_hour| { "datetime" => unoccupied_hour, "busy" => 0 } }
    
    calendar = busy_hours_noted + unoccupied_hours_noted

    calendar.sort {|a,b| a["datetime"] <=> b["datetime"] }
  end

  def self.group_by_day(agenda_of_the_week)
    agenda_of_the_week.group_by{ |slot| slot["datetime"].strftime("%A") }.values
  end

  def self.matching_hours_for_meeting(agenda_by_day_1, agenda_by_day_2, duration)
    (0...5).to_a.each_with_object([]) do |day_of_the_week, array|
      (0...9).to_a.each do |hour_of_day|
        array << hours_for_meeting(agenda_by_day_1, agenda_by_day_2, day_of_the_week, hour_of_day, duration)
      end
    end.compact!
  end

  def self.hours_for_meeting(agenda_by_day_1, agenda_by_day_2, day_of_the_week, hour_of_day, duration)
    return unless hour_of_day + duration <= 9
    array_of_multiple_hours_meeting = (hour_of_day...(hour_of_day + duration)).each_with_object([]) do |hour_of_day, array|
      break if (agenda_by_day_1[day_of_the_week][hour_of_day]["busy"] == 1 || agenda_by_day_2[day_of_the_week][hour_of_day]["busy"] == 1)
      array << agenda_by_day_1[day_of_the_week][hour_of_day]["datetime"] if (agenda_by_day_1[day_of_the_week][hour_of_day]["busy"] == 0 && agenda_by_day_2[day_of_the_week][hour_of_day]["busy"] == 0)
    end
    return if array_of_multiple_hours_meeting.nil?
    agenda_by_day_1[day_of_the_week][hour_of_day]["datetime"] if array_of_multiple_hours_meeting.count == duration
  end

  def self.format_data_for_output(matching_hours_for_meeting, duration)
    matching_hours_for_meeting.map do |hour|
      { 
        "start": hour,
        "end": hour + duration.send(:hour)
      }
    end
  end

  def self.return_free_slots_for_meetings(output)
    File.open('./output.json', 'w') do |f|
      f.write(output.to_json)
    end
  end
end

Main.call
