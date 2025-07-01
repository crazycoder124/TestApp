# Dockerfile for the Hello Docker application
# Use the official .NET SDK image to build the application
# FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base

# WORKDIR /app

# COPY /published .

# ENTRYPOINT [ "dotnet", "hello-docker.dll" ]

# EXPOSE 8090


#using Multistage build to reduce image size
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish "MyWebApp.csproj" -o /published /p:UseAppHost=false


FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
COPY --from=build /published .
ENTRYPOINT [ "dotnet", "MyWebApp.dll" ]
