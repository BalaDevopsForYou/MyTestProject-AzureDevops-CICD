# Stage 1: Build and extract the application from the zip file
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy the zip file from the artifact staging directory
COPY ./MyTestProject.zip /app/MyTestProject.zip

# Extract the contents of the zip file
RUN apt-get update && apt-get install -y unzip && \
    unzip MyTestProject.zip -d . && \
    rm MyTestProject.zip

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app

# Copy the extracted files from the build stage
COPY --from=build /app .

# Expose the necessary port (adjust if necessary)
EXPOSE 80

# Set the entry point to run the application
ENTRYPOINT ["dotnet", "MyTestProject.dll"]

