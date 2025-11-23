# 1. Build Phase
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .

# === INVESTIGATION COMMAND ===
# This will print your entire folder structure to the logs.
# We need this to find where 'pom.xml' and 'bayan_ticket' actually are.
RUN echo ">>>>>> LISTING ALL FILES <<<<<<" && \
    find . -maxdepth 3 -not -path '*/.*' && \
    echo ">>>>>> END OF LIST <<<<<<"
# =============================

# Try to find pom.xml automatically and build it
RUN mvn -f $(find . -name pom.xml | head -n 1) clean package -DskipTests

# 2. Run Phase
FROM tomcat:10.1-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*

# Try to copy the WAR file
COPY --from=build /app/**/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]