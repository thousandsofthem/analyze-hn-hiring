def open(url)
  Timeout::timeout(60) do
    Net::HTTP.get(URI.parse(url))
  end
end


def open_and_cache(id)
  id = id.to_i
  return if id <= 0

  fname = File.join(CACHE_DIR, id.to_s)
  if File.exists?(fname)
    File.read(fname)
  else
    data = open("https://news.ycombinator.com/item?id=#{id}")
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

