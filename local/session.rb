include Java

def init
  Dir["*.jar"].each { |jar| $CLASSPATH << jar }

  java_import "org.springframework.context.support.ClassPathXmlApplicationContext"

  java_import "org.jsoup.Jsoup"

  java_import "org.jsoup.nodes.Document"

  java_import "java.io.File"

  java_import "java.util.stream.Collectors"

  java_import "java.util.ArrayList"

  $ctx = ClassPathXmlApplicationContext.new "jruby.xml"

  $dl = $ctx.getBean "downloader"

  $etrade = $ctx.getBean "etrade"

  $repos = $ctx.getBean "stockMarketRepos"

  $f = File.new "/home/rcs/opt/haskell/etradejanitor/feed/2018/11/23/NHY.html"

  $doc = Jsoup.parse($f, "UTF-8")

  $el = $doc.getElementsByClass "com topmargin"
end


def optionName(tds)
  myEl = tds.get 0
  a = myEl.getElementsByTag "a"
  a.text
end

def optionType(tds)
  myEl = tds.get 1
  myEl.text
end
def exercise(tds)
  myEl = tds.get 2
  myEl.text
end
def expiry(tds)
  myEl = tds.get 3
  "expiry: " + myEl.text
end
def buy(tds)
  myEl = tds.get 4
  "Buy: " + myEl.text
end
def sell(tds)
  myEl = tds.get 5
  "Sell: " + myEl.text
end

def processOption(el)
  tds = el.children
  puts optionName tds
  puts optionType tds
  puts exercise tds
  puts expiry tds
  puts buy tds
  puts sell tds
end

$filterLamb = ->(v) {
    puts v
    optionName v == "NHY8L30"
}

def run
  f = $el.first
  puts f.getClass.getName
  fx = f.getElementsByTag "tr"
  fxx = fx.get(3)
  processOption fxx
end

def checkNode(tr)
  sz = tr.childNodeSize
  if sz > 15
    ch = tr.child(9).text
    puts "#{ch} #{sz}"
  end
end

def run2
  f = $el.first
  fx = f.getElementsByTag "tr"
  # puts fx.get(4).child(1)
  fx.each {|td| checkNode td }
end

def testNode
  f = $el.first
  fx = f.getElementsByTag "tr"
  fx.get(4)
end

def run3
  f = $el.first
  fx = f.getElementsContainingOwnText "American call"
  fx.each {|x|
    cz = x.parent.childNodeSize
    if cz > 15
      buy = x.parent.child(4).text
      sell = x.parent.child(5).text
      puts "Buy #{buy}, sell #{sell}"
    end}
end

init
