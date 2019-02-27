package harborview.service;

import org.apache.log4j.PropertyConfigurator;
import org.eclipse.jetty.server.*;
import org.eclipse.jetty.util.ssl.SslContextFactory;
import org.eclipse.jetty.webapp.WebAppContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.util.Properties;

//import org.eclipse.jetty.util.log.StdErrLog;

public class EmbeddedJetty {
    private static final Boolean DEBUG = true;
    private static final Boolean JETTY_DUMP = false;

    // https://wiki.eclipse.org/Jetty/Tutorial/Embedding_Jetty
    private static final Logger LOGGER = LoggerFactory.getLogger(EmbeddedJetty.class);

    private static final int PORT = 6346;
    
    private static final String WEBAPP_DIRECTORY = "webapp";
    
    public static void main(String[] args) throws Exception {
        startJettySSL(9998);
    }

    private static String getResourceBasePath() throws IOException {
        if (DEBUG) {
            return "file:/home/rcs/opt/java/harborview/src/main/resources/webapp";
        }
        else {
            String cpr = new ClassPathResource(WEBAPP_DIRECTORY).getURI().toString();
            return cpr;
        }
    }
    private static void startJettySSL(int port) throws Exception {
        WebAppContext context = new WebAppContext();
        String webapp = getResourceBasePath();
        context.setDescriptor(webapp+"/WEB-INF/web.xml");
        context.setResourceBase(webapp);
        context.setContextPath("/");
        context.setParentLoaderPriority(true);

        Server server = new Server();
        server.setHandler(context);


        HttpConfiguration https = new HttpConfiguration();
        https.addCustomizer(new SecureRequestCustomizer());

        SslContextFactory sslContextFactory = new SslContextFactory();
        // keytool -genkey -alias sitename -keyalg RSA -keystore keystore.jks -keysize 2048
        sslContextFactory.setKeyStorePath("file:///home/rcs/opt/java/harborview/keystore.jks");
        sslContextFactory.setKeyStorePassword("123456");
        sslContextFactory.setKeyManagerPassword("123456");
        ServerConnector sslConnector = new ServerConnector(server,
                new SslConnectionFactory(sslContextFactory, "http/1.1"),
                new HttpConnectionFactory(https));
        sslConnector.setPort(port);

        server.setConnectors(new Connector[] { sslConnector });
        server.start();
        server.join();
    }

    private static void startJetty(int port) throws Exception {
        initLog4j();

        WebAppContext context = new WebAppContext();
        String webapp = getResourceBasePath();
        context.setDescriptor(webapp+"/WEB-INF/web.xml");
        context.setResourceBase(webapp);
        context.setContextPath("/");
        context.setParentLoaderPriority(true);

        /*
        context.setConfigurations(new Configuration[]
                {new WebXmlConfiguration(), new WebInfConfiguration()});
                //new PlusConfiguration(), new MetaInfConfiguration(), new FragmentConfiguration(), new EnvConfiguration() });
        */

        Server server = new Server(port);
        server.setHandler(context);

        server.start();
        if (JETTY_DUMP) {
            server.dump(System.err);
        }
        server.join();
    }

    private static void initLog4j() {
        Properties props = new Properties();
        try {

            props.load(EmbeddedJetty.class.getResourceAsStream("/log4j.xml"));
            PropertyConfigurator.configure(props);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

//    private void startJetty2(int port) throws Exception {
//        ServletContextHandler context = new ServletContextHandler(ServletContextHandler.SESSIONS);
//        context.setContextPath("/");
//        server.setHandler(context);
//
//        context.addServlet(new ServletHolder(new HelloServlet()),"/*");
//        context.addServlet(new ServletHolder(new HelloServlet("Buongiorno Mondo")),"/it/*");
//        context.addServlet(new ServletHolder(new HelloServlet("Bonjour le Monde")),"/fr/*");
//
//        server.start();
//        server.join();
//    }
//    private void startJetty1(int port) throws Exception {
//        Server server = new Server(port);
//
//        ContextHandler context = new ContextHandler();
//        context.setContextPath("/hello");
//        context.setResourceBase(".");
//        context.setClassLoader(Thread.currentThread().getContextClassLoader());
//        server.setHandler(context);
//
//        context.setHandler(new HelloHandler());
//
//        server.start();
//        server.join();
//    }
//
//    private void xstartJetty(int port) throws Exception {
//        LOGGER.debug("Starting server at port {}", port);
//        Server server = new Server(port);
//
//        server.setHandler(getServletContextHandler());
//
//        addRuntimeShutdownHook(server);
//
//        server.start();
//        LOGGER.info("Server started at port {}", port);
//        server.join();
//    }
//
//    private static ServletContextHandler getServletContextHandler() throws IOException {
//        ServletContextHandler contextHandler = new ServletContextHandler(ServletContextHandler.SESSIONS); // SESSIONS requerido para JSP
//        contextHandler.setErrorHandler(null);
//
//        String webapp = new ClassPathResource(WEBAPP_DIRECTORY).getURI().toString();
//        contextHandler.setResourceBase(webapp);
//        //contextHandler.setResourceBase("file://home/rcs/opt/java/harborview/src/main/webapp");
//        contextHandler.setContextPath(CONTEXT_PATH);
//
//        // JSP
//        //contextHandler.setClassLoader(Thread.currentThread().getContextClassLoader()); // Necesario para cargar JspServlet
//        //contextHandler.addServlet(JspServlet.class, "*.jsp");
//
//        // Spring
//        WebApplicationContext webAppContext = getWebApplicationContext();
//        DispatcherServlet dispatcherServlet = new DispatcherServlet(webAppContext);
//        ServletHolder springServletHolder = new ServletHolder("mvc-dispatcher", dispatcherServlet);
//        contextHandler.addServlet(springServletHolder, MAPPING_URL);
//        contextHandler.addEventListener(new ContextLoaderListener(webAppContext));
//        return contextHandler;
//    }
//
//    private static WebApplicationContext getWebApplicationContext() {
//        AnnotationConfigWebApplicationContext context = new AnnotationConfigWebApplicationContext();
//        context.setConfigLocation(CONFIG_LOCATION_PACKAGE);
//        return context;
//        XmlWebApplicationContext context = new XmlWebApplicationContext();
//        context.setConfigLocation("/WEB-INF");
//        return context;
//    }
//
//    private static void addRuntimeShutdownHook(final Server server) {
//		Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
//            @Override
//            public void run() {
//                if (server.isStarted()) {
//                	server.setStopAtShutdown(true);
//                    try {
//                    	server.stop();
//                    } catch (Exception e) {
//                        System.out.println("Error while stopping jetty server: " + e.getMessage());
//                        LOGGER.error("Error while stopping jetty server: " + e.getMessage(), e);
//                    }
//                }
//            }
//        }));
//	}

}

//        For Example you can create VirtualHosts with ServletContextHandler and you can management context easily. That means different context handlers on different ports.
//
//        Server server = new Server();
//        ServerConnector pContext = new ServerConnector(server);
//        pContext.setPort(8080);
//        pContext.setName("Public");
//        ServerConnector localConn = new ServerConnector(server);
//        localConn.setPort(9090);
//        localConn.setName("Local");
//
//        ServletContextHandler publicContext = new ServletContextHandler(ServletContextHandler.SESSIONS);
//        publicContext.setContextPath("/");
//        ServletHolder sh = new ServletHolder(new HttpServletDispatcher());  sh.setInitParameter("javax.ws.rs.Application", "ServiceListPublic");
//        publicContext.addServlet(sh, "/*");
//        publicContext.setVirtualHosts(new String[]{"@Public"});
//
//
//        ServletContextHandler localContext = new ServletContextHandler(ServletContextHandler.SESSIONS);
//        localContext .setContextPath("/");
//        ServletHolder shl = new ServletHolder(new HttpServletDispatcher()); shl.setInitParameter("javax.ws.rs.Application", "ServiceListLocal");
//        localContext.addServlet(shl, "/*");
//        localContext.setVirtualHosts(new String[]{"@Local"}); //see localConn.SetName
//
//
//        HandlerCollection collection = new HandlerCollection();
//        collection.addHandler(publicContext);
//        collection.addHandler(localContext);
//        server.setHandler(collection);
//        server.addConnector(pContext);
//        server.addConnector(localContext);
