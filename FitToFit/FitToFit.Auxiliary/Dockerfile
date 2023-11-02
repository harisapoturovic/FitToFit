#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["FitToFit.Auxiliary/FitToFit.Auxiliary.csproj", "FitToFit.Auxiliary/"]
RUN dotnet restore "FitToFit.Auxiliary/FitToFit.Auxiliary.csproj"
COPY . .
WORKDIR "/src/FitToFit.Auxiliary"
RUN dotnet build "FitToFit.Auxiliary.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FitToFit.Auxiliary.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "FitToFit.Auxiliary.dll"]