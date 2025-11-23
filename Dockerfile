# 1. Build Phase
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .

# Run Maven
RUN mvn clean package -DskipTests

# --- DEBUGGING COMMAND ---
# This will print the location of every file to the Build Logs
RUN echo "=============================" && \
    echo "WHERE IS THE WAR FILE?" && \
    find . -name "*.war" && \
    echo "============================="
# -------------------------

# 2. Run Phase
FROM tomcat:10.1-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*

# Try to find the WAR file using a "Deep Search" (Wildcard)
COPY --from=build /app/**/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]