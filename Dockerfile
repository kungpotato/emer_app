FROM instrumentisto/flutter:3.13.5

WORKDIR /app

COPY . .

RUN flutter pub get