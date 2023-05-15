require 'open-uri'


def curl_base
  <<~HEREDOC
  curl '{{URL}}' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'Accept-Language: ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7' \
  -H 'Cache-Control: max-age=0' \
  -H 'Connection: keep-alive' \
  -H 'Cookie: user=out_of_protocol&YBlfWAcAJDgZ2Cdx1rfIuIjkHuAYpfkJ' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-Site: none' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36' \
  -H 'sec-ch-ua: "Not:A-Brand";v="99", "Chromium";v="112"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  --compressed
  HEREDOC
end


def open(url)
  #ua = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36'
  Timeout::timeout(60) do

    cmd = curl_base().gsub('{{URL}}', url)
    `#{cmd}`
   # URI.open(url, 'User-Agent' => ua, 'Accept-Language' => 'ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7').read
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

