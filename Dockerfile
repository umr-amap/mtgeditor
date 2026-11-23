# Étape 1 : Compilation de l'application Flutter Web
FROM debian:bookworm-slim AS build

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Clonage direct du SDK officiel Flutter (garantit Dart >= 3.13.5)
RUN git clone --depth 1 --branch 3.47.7 https://github.com/flutter/flutter.git /opt/flutter \
    || git clone --depth 1 --branch stable https://github.com/flutter/flutter.git /opt/flutter

ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Préchargement uniquement du moteur Web (évite de télécharger Android/iOS)
RUN flutter config --no-analytics --enable-web && flutter precache --web

WORKDIR /workspace
COPY . .

WORKDIR /workspace/apps/mtg_editor
RUN flutter pub get
RUN flutter build web --release -t lib/app/main.dart

# Étape 2 : Serveur web léger pour exposer l'application
FROM nginx:alpine

COPY --from=build /workspace/apps/mtg_editor/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]