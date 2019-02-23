FROM anapsix/alpine-java:8_server-jre

RUN mkdir -p /home/rcs/harborview

COPY *.jar /home/rcs/harborview/

COPY critters-dbcp.properties /home/rcs/harborview/

WORKDIR /home/rcs/harborview

# CMD ["java", "jar", "/home/rcs/harborview/harborview-0.9.jar"]

CMD ["java", "-jar", "harborview-0.9.jar"]
