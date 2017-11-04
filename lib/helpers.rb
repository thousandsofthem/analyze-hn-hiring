def open(url)
  Timeout::timeout(60) do
    Net::HTTP.get(URI.parse(url))
  end
end


def open_and_cache(id, page_num = 1, use_cache = true)
  id = id.to_i
  return if id <= 0

  fname = File.join(CACHE_DIR, "#{id.to_s}-#{page_num.to_s}.html")
  if use_cache && File.exists?(fname)
    File.read(fname)
  else
    url = "https://news.ycombinator.com/item?id=#{id}"
    if page_num > 1
      url += "&p=#{page_num}"
    end
    data = open(url)
    if data.size > 0
      File.write(fname, data)
      data
    else
      raise("can not load story ##{id}")
    end
  end
end

def clean_stats(date)
  Keyword.where(date: date).delete_all
end

def store_stats(date, keywords, count)
  Keyword.create!(date: date, keyword: keywords, count: count)
end

