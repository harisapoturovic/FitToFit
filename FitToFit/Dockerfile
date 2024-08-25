FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5058
ENV ASPNETCORE_URLS=http://+:5058

# Install telnet and other necessary tools
RUN apt-get update && apt-get install -y telnet curl

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .

FROM build AS publish
RUN dotnet publish "FitToFit/FitToFit.csproj" -c Release -o /app
FROM base AS final
WORKDIR /app
COPY --from=publish /app .

ENTRYPOINT ["dotnet", "FitToFit.dll"]