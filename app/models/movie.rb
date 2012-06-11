class Movie < ActiveRecord::Base
  def self.get_all_ratings
    Movie.find(:all).map {|m|  m['rating']}.uniq
  end
end
