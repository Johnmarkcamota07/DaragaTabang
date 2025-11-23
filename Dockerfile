# 1. Build the app using Maven
FROM maven:3.8.5-openjdk-17 AS build
COPY . .
RUN mvn clean package -DskipTests

# 2. Run the app using Tomcat
FROM tomcat:10.1-jdk17
# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy the WAR file to the webapps folder
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]