FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build-env
WORKDIR /App

# Copy repository content so project paths resolve from root context
COPY . ./

# Build and publish project
RUN dotnet publish Kaven-DDNS/Kaven-DDNS.csproj -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime:10.0
WORKDIR /App
COPY --from=build-env /App/out .

LABEL name="Kaven-DDNS" \
    author="Kaven" \
    email="kaven@wuwenkai.com" \
    version="1.0.0" \
    description="Dynamic DNS client for monitoring public IP changes, sending notifications, and auto-updating AliDNS records."

EXPOSE 514/udp

ENTRYPOINT ["dotnet", "Kaven-DDNS.dll"]