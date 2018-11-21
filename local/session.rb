include Java

Dir["*.jar"].each { |jar| $CLASSPATH << jar }

java_import "org.springframework.context.support.ClassPathXmlApplicationContext"

$ctx = ClassPathXmlApplicationContext.new "jruby.xml"

$dl = $ctx.getBean "downloader"
