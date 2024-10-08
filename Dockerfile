# Stage 1: Build and extract the application from the zip file
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy the zip file from the artifact staging directory
COPY ./MyTestProject.zip /app/MyTestProject.zip

# Extract the contents of the zip file and clean up
RUN apt-get update && apt-get install -y --no-install-recommends unzip && \
    unzip MyTestProject.zip -d . && \
    rm MyTestProject.zip && \
    apt-get remove -y unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Stage 2: Set up the runtime environment
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app

# Copy the extracted files from the build stage
COPY --from=build /app .

# Set environment variables
ENV ASPNETCORE_URLS=http://+:80 \
    ASPNETCORE_ENVIRONMENT=Production

# Expose the necessary port
EXPOSE 80

# Set the entry point to run the application
ENTRYPOINT ["dotnet", "MyTestProject.dll"]
