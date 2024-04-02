FROM eclipse-temurin:17-jdk-alpine
RUN useradd --uid 10000 app
USER 10000
VOLUME /tmp
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]