# Use a reliable JDK 17 image
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app

# Copy sources first (helps leverage Docker cache)
COPY .mvn/ .mvn/
COPY mvnw .
COPY pom.xml .
COPY src ./src

# Ensure mvnw is executable and use it to build
RUN chmod +x mvnw
RUN ./mvnw -B -DskipTests clean package

# Create runtime image with only the JRE/JDK and built artifact
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app
ENV JAVA_HOME=/usr/lib/jvm/jammy-temurin-17-jdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["sh","-c","exec java -jar /app/app.jar"]
