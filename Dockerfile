# Dockerfile for the Hello Docker application
# Use the official .NET SDK image to build the application
# FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base

# WORKDIR /app

# COPY /published .

# ENTRYPOINT [ "dotnet", "hello-docker.dll" ]

# EXPOSE 8090


#using Multistage build to reduce image size
# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj and restore
COPY ./MyApp.Web/MyWebApp.csproj ./MyApp.Web/
RUN dotnet restore "./MyApp.Web/MyWebApp.csproj"

# Copy the rest and publish
COPY . .
RUN dotnet publish "./MyApp.Web/MyWebApp.csproj" -c Release -o /published /p:UseAppHost=false

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
COPY --from=build /published .
ENTRYPOINT [ "dotnet", "MyWebApp.dll" ]

