require "byebug"

class Calendar
  def self.leap_year?(year)
    (683*year).modulo(2820) < 683
  end

  def self.day_of_year(date)
    @@calendar_date["#{date.day}-#{date.month_name}"]
  end

  def self.init
    @@calendar_date = {}
    months = MONTHS.cycle
    days = DAYS.cycle

    0.upto(363) do |i|
      key = "#{days.next}-#{months.next}"
      @@calendar_date[key] = i
    end
    @@calendar_date
  end

  MONTHS = [
    "Alligator".freeze, "Bog".freeze, "Cray".freeze,
    "Damp".freeze, "Eel".freeze, "Fen".freeze,
    "Gumbo".freeze, "Hurricane".freeze, "Inundation".freeze,
    "Jaguar".freeze, "Kudzu".freeze, "Lake".freeze,
    "Marsh".freeze
  ]

  ALL_MONTHS = [
    *MONTHS,
    "Newt".freeze, "Overflow".freeze
  ]

  NEWT = MONTHS.index "Newt".freeze
  OVERFLOW = MONTHS.index "Overflow".freeze

  DAYS = 0.upto(27)

  LEAP_DAYS = (0...2820)
              .map(&method(:leap_year?))
              .each_with_index
              .map { |leap, idx| idx if leap }
              .compact

  class Date
    include Comparable

    attr_accessor :day, :month, :year

    def initialize(date_str)
      @day, @month, @year = date_str.split "-"
      @day = @day.to_i
      @month = Calendar::ALL_MONTHS.index { |m| m =~ /^#{@month.to_s}/i }
      @year = @year.to_i
    end

    def valid?
      case month
      when 14 then validate_overflow
      when 13 then validate_newt
      else validate_28d_month
      end
    end

    def ordinal_day
      case month
      when 14 then 365
      when 13 then 364
      else Calendar.day_of_year(self)
      end
    end

    def month_name
      Calendar::ALL_MONTHS[month]
    end

    def <=>(other)
      y = year <=> other.year
      m = month <=> other.month
      d = day <=> other.day

      y == 0 ? (m == 0 ? d : m) : y
    end

    def to_s
      "#{day}-#{Calendar::ALL_MONTHS[month]}-#{year}"
    end

    private

    def validate_newt
      day == 0
    end

    def validate_overflow
      Calendar.leap_year?(year) &&
        Calendar::LEAP_DAYS[day] == year.modulo(2820)
    end

    def validate_28d_month
      Calendar::DAYS.include?(day) && month && year >= 0
    end
  end

  def self.diff(date_1, date_2)
    _date_1 = Date.new(date_1)
    _date_2 = Date.new(date_2)

    earlier, later = [_date_1, _date_2].sort

    return "eh?" unless earlier.valid? && later.valid?

    leap_count = 0
    earlier.year.upto(later.year - 1) do |year|
      leap_count += 1 if Calendar.leap_year? year
    end

    e_to_ny = earlier.ordinal_day
    l_to_ny = later.ordinal_day

    d_years = later.year - earlier.year
    from_years = d_years * 365

    l_to_ny - e_to_ny + from_years + leap_count
  end
end

def assert(expected, actual)
  if expected == actual
    puts "Ok"
  else
    puts "expected #{expected}, but got #{actual}"
  end
end

Calendar.init

t0 = Time.now
assert(1033635, Calendar.diff("0-Alli-0", "2-Overflow-2829"))
assert("eh?", Calendar.diff("0-alli-0", "3-Over-2829"))
assert(730484396, Calendar.diff("0-a-0", "0-newt-1999999"))
assert("eh?", Calendar.diff("0-alligator-1997", "28-bog-2000"))
assert(377773883, Calendar.diff("16-jaguar-1054284", "16-gum-19973"))
assert(71606355, Calendar.diff("23-damp-394304", "0-newt-590355"))
assert(325343964, Calendar.diff("43-over-1948798", "20-mar-1058036"))

t1 = Time.now

puts t1 - t0
