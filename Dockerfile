# 1. Build Phase
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .

# DIAGNOSTIC: Show us where the pom.xml actually is
RUN echo "Looking for pom.xml..." && find . -name "pom.xml"

# SMART BUILD:
# This command tells Maven: "Find the pom.xml file yourself and build THAT one."
# It fixes the issue where Maven builds the wrong (empty) root folder.
RUN mvn -f $(find . -name pom.xml | head -n 1) clean package -DskipTests

# DIAGNOSTIC: Did it work this time?
RUN echo "Looking for generated WAR file..." && find . -name "*.war"

# 2. Run Phase
FROM tomcat:10.1-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*

# SMART COPY:
# Find the WAR file anywhere inside the 'target' folder and copy it.
COPY --from=build /app/**/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]