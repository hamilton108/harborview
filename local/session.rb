include Java

def init
  Dir["*.jar"].each { |jar| $CLASSPATH << jar }

  java_import "org.springframework.context.support.ClassPathXmlApplicationContext"

  java_import "org.jsoup.Jsoup"

  java_import "org.jsoup.nodes.Document"

  java_import "java.io.File"

  $ctx = ClassPathXmlApplicationContext.new "jruby.xml"

  $dl = $ctx.getBean "downloader"

  $f = File.new "/home/rcs/opt/haskell/etradejanitor/feed/2018/11/23/NHY.html"

  $doc = Jsoup.parse($f, "UTF-8")

  $el = $doc.getElementsByClass "com topmargin"
end

#init

def optionName(tds)
  myEl = tds.get 0
  a = myEl.getElementsByTag "a"
  a.text
end

def optionType(tds)
  myEl = tds.get 1
  myEl.text
end

def processOption(el)
  tds = el.children
  puts optionName tds
  puts optionType tds
end

def run
  f = $el.first
  fx = f.getElementsByTag "tr"
  fxx = fx.get(10)
  processOption fxx
end
