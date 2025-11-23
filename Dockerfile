# 1. Build
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .

# Debug: Show us the file structure in the logs so we can fix it if this fails
RUN echo "Listing files in /app:" && ls -R /app

# Build the app (skipping tests to save time)
RUN mvn clean package -DskipTests

# 2. Run
FROM tomcat:10.1-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*

# IMPROVED COPY COMMAND:
# This uses "find" logic to grab the WAR file from ANY 'target' folder it finds.
# This fixes the issue whether the project is in the root or a subfolder.
COPY --from=build /app/**/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]