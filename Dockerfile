FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy the entire project
COPY . .

# IMPORTANT: Walk into the folder where pom.xml is
WORKDIR /app/bayan_ticket

# Build
RUN mvn clean package -DskipTests

# Run
FROM tomcat:10.1-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file (Path includes the subfolder)
COPY --from=build /app/bayan_ticket/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]