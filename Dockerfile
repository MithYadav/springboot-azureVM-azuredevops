# =========================
# Stage 1 - Build
# =========================
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy only pom.xml first (for better layer caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# =========================
# Stage 2 - Runtime
# =========================
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copy only the JAR from build stage
COPY --from=build /app/target/*.jar app.jar

# Create non-root user for security
RUN addgroup --system spring && adduser --system --group spring
USER spring:spring

# Expose port
EXPOSE 8080

# Health check (optional but recommended)
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", \
    "-XX:+UseContainerSupport", \
    "-XX:MaxRAMPercentage=75.0", \
    "-Djava.security.egd=file:/dev/./urandom", \
    "-jar", \
    "app.jar"]
