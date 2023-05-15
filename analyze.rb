require 'rubygems'
require 'bundler/setup'
require "./lib/loader.rb"

FORCE_UPDATE_LAST_MONTH = false


CONFIG = YAML::load(File.open(File.join(File.dirname(__FILE__), 'config.yml')))
CACHE_DIR = File.join(File.dirname(__FILE__), 'cache')

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = 1
ActiveRecord::Base.establish_connection(CONFIG["db"])
Time.zone = "UTC"

puts "Start"

puts "records in db: #{Keyword.count}"

puts "pages to check: #{CONFIG["pages"].count}"

#`rm ./cache/#{CONFIG["pages"].first.to_i}`

puts CONFIG["pages"].inspect

use_cache = true
if FORCE_UPDATE_LAST_MONTH
  use_cache = false
end

CONFIG["pages"].each do |page_id|

  puts "== checking page #{page_id} ".ljust(80, "=")
  total = 0
  stats = {}
  date = nil
  (1..10).each do |int_page|
    puts "##{int_page}"
    doc = Nokogiri::HTML(open_and_cache(page_id, int_page, use_cache))
    if int_page == 1
      date_raw = doc.css('title').text.sub(/^.*?\(/,'').sub(/\).*/,'')
      date = Time.zone.parse(date_raw) || raise("can not parse date")
      puts "raw: #{date_raw}, parsed: #{date}"
      clean_stats(date)
    end



    # downcase - to speedup search
    comments = doc.css(".comment-tree td.default").map { |node| node.css('.comment').text.downcase }
    puts "comments found: #{comments.count}"
    total += comments.count

    CONFIG["keywords"].each do |title, kwlist|
      ids = []
      kwlist.each do |kw|
        r = Regexp.new('\W(' + kw + ')\W', "i")
        comments.each_with_index do |comment, idx|
          ids << idx if comment.match(r) && !ids.include?(idx)
        end
      end
      stats[title] ||= 0
      stats[title] += ids.count
      #store_stats(date, title, ids.count)
      #puts "#{title.ljust(70, " ")} #{ids.count.to_s.rjust(4, " ")} comments"
    end
    if doc.css('a.morelink').count < 1
      break
    end
  end # end int page

  store_stats(date, "TOTAL", total)
  stats.each do |k, v|
    store_stats(date, k, v)
  end



  puts "\n"
  use_cache = true
end







puts "\nEnd\n"