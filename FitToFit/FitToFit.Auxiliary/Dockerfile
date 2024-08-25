FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["FitToFit.Auxiliary.csproj", "FitToFit.Auxiliary/"]
RUN dotnet restore "FitToFit.Auxiliary/FitToFit.Auxiliary.csproj"

WORKDIR "/src/FitToFit.Auxiliary"
COPY . .

RUN dotnet build "FitToFit.Auxiliary.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FitToFit.Auxiliary.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "FitToFit.Auxiliary.dll"]
