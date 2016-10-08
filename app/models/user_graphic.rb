require 'date'
require 'time'
class UserGraphic

  attr_accessor :value,:labels,:title,:id,:chart,:option
  #Constructor
  def initialize(chart,id)
    @chart = chart
    @title = ""
    @id=id
  end

  def generate_per_year(query,title)
    months = ["January","February","March","April","May","June","July","August","September","October","November","Dicember"];
    dates = ["-01-01","-02-01","-03-01","-04-30","-05-01","-06-01","-07-01","-08-01","-09-01","-10-01","-11-01","-12-01"];
    values = Array.new(months.length,0);
    year = Time.now.year.to_s
    for i in 0..months.length-2
      totalusers = Spree::User.where( query+" > :start_date AND "+query+" <= :end_date",{start_date: year+dates[i], end_date: year+dates[i+1] }).count
      values[i] += totalusers
    end
    values[values.length-1] = totalusers = Spree::User.where(query+" >= :start_date",{start_date: year+dates[dates.length-1]}).count


    @title = title + " in last 30 days"
    @labels = months.to_s
    @value = values.to_s

  end

  def generate_per_month(query,title)
    days = []
    for i in 1..30
      days.push(i.to_s)
    end
    dates = []
    i = days.length
    while i >0
      dates.push(i.day.ago.to_s.split(" ")[0])
      i-=1
    end
    values = Array.new(days.length,0)
    for i in 0..dates.length-2
      totalusers = Spree::User.where( query+" > :start_date AND "+query+" <= :end_date",{start_date: dates[i], end_date:dates[i+1] }).count
      values[i] += totalusers
    end
    values[values.length-1] = totalusers = Spree::User.where(query+" >= :start_date",{start_date: dates[dates.length-1]}).count


    @title = title + " in last 30 days"
    @labels = days.to_s
    @value = values.to_s

  end

  def generate_per_week(query,title)
    days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    day= Time.now.strftime("%A")
    days[days.index(day)] = "Today"
    dates = []
    i = days.length
    while i >0
      dates.push(i.day.ago.to_s.split(" ")[0])
      i-=1
    end
    values = Array.new(days.length,0)
    for i in 0..dates.length-2
      totalusers = Spree::User.where(query+" > :start_date AND "+query+" <= :end_date",{start_date: dates[i], end_date:dates[i+1] }).count
      values[i] += totalusers
    end
    values[values.length-1] = Spree::User.where(query + " >= :start_date",{start_date: dates[dates.length-1]}).count


    @value =values.to_s
    @title = title + " in last 30 days"
    @labels = days.to_s

  end

  #Does a query getting the new producers per period.
  def generate_per_period(period)
    title = "New users"
    query = "created_at"
    #Array containing each type value
    if period == "Year"
      generate_per_year(query,title)
    elsif period == "Month"
      generate_per_month(query,title)
    elsif period == "Week"
      generate_per_week(query,title)
    end

  end

  #Does a query getting the conexions per period.
  def conexions_per_period(period)
    title = "User conexions "
    query = "last_sign_in_at"
    #Array containing each type value
    if period == "Year"
      generate_per_year(query,title)
    elsif period == "Month"
      generate_per_month(query,title)
    elsif period == "Week"
      generate_per_week(query,title)
    end

  end

  def includes?(arr)
    for i in arr
      if @chart == i.chart && @title == i.title
        return true
      end
    end
    return false
  end

end