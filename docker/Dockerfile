FROM anapsix/alpine-java:8_server-jre

RUN mkdir -p /home/rcs/harborview

COPY *.jar /home/rcs/harborview/

WORKDIR /home/rcs/harborview 

CMD ["java", "jar", "harborview-0.9"]
