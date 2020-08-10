# Award = Struct.new(:name, :expires_in, :quality)
class Award
  # not really used. This could be improved
  attr_accessor :name, :expires_in, :quality

  MAX_QUALITY = 50
  def initialize(name, expires_in, quality)
    @name = name
    @expires_in = expires_in
    @quality = quality
    @expires_in -= 1 unless @name == 'Blue Distinction Plus'
  end

  def before_expiration?
    @expires_in > 0
  end

  def on_expiration?
    @expires_in == 0
  end

  def after_expiration?
    @expires_in < 0
  end

  def zero_quality?
    @quality == 0
  end

  def max_quality?
    @quality == MAX_QUALITY
  end

  def near_max?
    @quality == MAX_QUALITY - 1
  end

  def long_before_expiration?
    @expires_in > 9
  end

  def medium_upper_bound?
    @expires_in == 9
  end

  def medium_lower_bound?
    @expires_in == 5
  end

  def very_close_upper_bound?
    @expires_in == 4
  end

  def very_close_lower_bound?
    @expires_in == 0
  end

  def update_quality
    case @name
    when 'Blue First'
      blue_first_quality_rule
    when 'Blue Distinction Plus'
      blue_distinction_plus_rule
    when 'Blue Compare'
      blue_compare_quality_rule
    when 'Blue Star'
      blue_star_quality_rule
    else
      normal_award_quality_rule
    end
  end

  private

  def blue_distinction_plus_rule
    @quality if before_expiration? || on_expiration? || after_expiration?
  end

  def blue_first_quality_rule
    return @quality = MAX_QUALITY if max_quality? || near_max?
    @quality += 1 if before_expiration?
    @quality += 2 if on_expiration? || after_expiration?
  end

  def normal_award_quality_rule
    return @quality = 0 if zero_quality?
    @quality -= 1 if before_expiration?
    @quality -= 2 if on_expiration? || after_expiration?
  end

  def blue_compare_quality_rule
    return @quality = MAX_QUALITY if max_quality?
    return @quality += 1 if long_before_expiration?
    return @quality += 2 if medium_upper_bound? || medium_lower_bound?
    return @quality += 3 if very_close_upper_bound? || very_close_lower_bound?
    return @quality = 0 if on_expiration? || after_expiration?
  end

  def blue_star_quality_rule
    return @quality = 0 if zero_quality?
    @quality -= 2 if before_expiration?
    @quality -= 4 if on_expiration? || after_expiration?
  end

end
