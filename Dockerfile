# 1. Build Phase
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .

# Build the app
RUN mvn clean package -DskipTests

# DIAGNOSTIC: Verify the WAR file was actually created
RUN echo "Checking target folder content:" && ls -l target/

# 2. Run Phase
FROM tomcat:10.1-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*

# COPY COMMAND (Fixed for Root Project):
# We go directly to /app/target/ because we know the files are there.
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]