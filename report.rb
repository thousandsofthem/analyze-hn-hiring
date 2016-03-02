require 'rubygems'
require 'bundler/setup'
require "./lib/loader.rb"


CONFIG = YAML::load(File.open(File.join(File.dirname(__FILE__), 'config.yml')))
CACHE_DIR = File.join(File.dirname(__FILE__), 'cache')

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = 1
ActiveRecord::Base.establish_connection(CONFIG["db"])
Time.zone = "UTC"

lines = Keyword.all.order("date ASC, keyword ASC").to_a

jsdata = {}
lines.map do |line|
  jsdata[line.keyword] ||= []
  jsdata[line.keyword] << [line.date.to_i * 1000, line.count]
end

fname = File.join(File.dirname(__FILE__), "public/assets/points.js")
File.write fname, "window.points = " + jsdata.to_json



# Normanized points
total_values = {}
lines.each do |line|
  if line.keyword == "TOTAL"
    total_values[line.date] = line.count
  end
end

jsdata = {}
lines.map do |line|
  next if line.keyword == "TOTAL"
  count = (100.0 * line.count.to_f / total_values[line.date]).round(2)
  jsdata[line.keyword] ||= []
  jsdata[line.keyword] << [line.date.to_i * 1000, count]
end

fname = File.join(File.dirname(__FILE__), "public/assets/points-normalized.js")
File.write fname, "window.points_normalized = " + jsdata.to_json





puts "\nEnd\n"