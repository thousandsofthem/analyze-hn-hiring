require 'rubygems'
require 'bundler/setup'
require "./lib/loader.rb"


CONFIG = YAML::load(File.open(File.join(File.dirname(__FILE__), 'config.yml')))
CACHE_DIR = File.join(File.dirname(__FILE__), 'cache')

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = 1
ActiveRecord::Base.establish_connection(CONFIG["db"])
Time.zone = "UTC"

puts "Start"

puts "records in db: #{Keyword.count}"

puts "pages to check: #{CONFIG["pages"].count}"


CONFIG["pages"].each do |page_id|

  puts "== checking page #{page_id} ".ljust(80, "=")

  doc = Nokogiri::HTML(open_and_cache(page_id))
  date_raw = doc.css('title').text.sub(/^.*?\(/,'').sub(/\).*/,'')
  date = Time.zone.parse(date_raw) || raise("can not parse date")
  puts "raw: #{date_raw}, parsed: #{date}"

  # downcase - to speedup search
  comments = doc.css(".comment-tree td.default").map { |node| node.css('.comment').text.downcase }
  puts "comments found: #{comments.count}"

  clean_stats(date)
  store_stats(date, "TOTAL", comments.count)
  CONFIG["keywords"].each do |kwlist|
    ids = []

    kws = kwlist.split("|").map(&:strip).map(&:downcase).sort
    r = Regexp.new('\W(' + kws.join("|") + ')\W', "i")
    comments.each_with_index do |comment, idx|
      ids << idx if comment.match(r)
    end
    keywords_normalized = kws.join(", ")
    store_stats(date, keywords_normalized, ids.count)
    puts "#{keywords_normalized.ljust(70, " ")} #{ids.count.to_s.rjust(4, " ")} comments"
  end


  puts "\n"
end







puts "\nEnd\n"