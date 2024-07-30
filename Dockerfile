# Используем образ .NET SDK 8.0 для сборки приложения
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Копируем csproj файл и восстанавливаем зависимости
COPY *.csproj ./
RUN dotnet restore --verbosity detailed

# Копируем всё остальное и собираем приложение
COPY . ./
RUN dotnet publish -c Release -o out

# Теперь создаем образ для запуска
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .

# Указываем команду для запуска приложения
ENTRYPOINT ["dotnet", "httpapi_pp.dll"]