# 1. Build Phase
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .

# SMART BUILD COMMAND:
# This finds your pom.xml automatically (no matter which folder it is in) and builds it.
RUN mvn -f $(find . -name pom.xml) clean package -DskipTests

# 2. Run Phase
FROM tomcat:10.1-jdk21
RUN rm -rf /usr/local/tomcat/webapps/*

# SMART COPY COMMAND:
# 1. Look inside any folder (**)
# 2. Look inside the 'target' folder
# 3. Grab ANY file that ends in .war OR .jar
# 4. Rename it to ROOT.war so Tomcat runs it.
COPY --from=build /app/**/target/*.*ar /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]