# Use Java 21
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy everything
COPY . .

# --- DEBUGGING STEP ---
# This prints all files to the logs so we can see where pom.xml is
RUN echo "listing files..." && ls -R
# ----------------------

# TRY OPTION A: Build from Root (Most likely fix)
# If your pom.xml is in the main folder, this works.
RUN mvn clean package -DskipTests

# Run with Tomcat
FROM tomcat:10.1-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*

# Find the WAR file automatically (wildcard)
COPY --from=build /app/**/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]