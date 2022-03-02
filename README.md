# docker compose

Docker compose untuk membuat sebuah container yang didalamnya terdapat service-service untuk aplikasi ePuskesmas.

## Prerequisite

* [Docker Compose CLI Overview](https://docs.docker.com/compose/reference/)

## Installation
Jalankan docker pada komputer / laptop.

- Buat folder epuskesmas lalu masuk, git clone repository https://github.com/odanicola/epuskesmas_5_dockerize
- Git clone repository epuskesmas_5 dengan nama epuskesmas_5
- Copy file-file yang ada pada folder resources ke folder epuskesmas_5/resources
- Copy file Dockerfile ke folder epuskesmas_5

Setelah step telah dilakukan, pastikan struktur projek seperti dibawah ini:

Struktur projek:
- epuskesmas (root)
    - epuskesmas_5
    - docker-compose.yml

Jalankan perintah:

```bash
docker-compose up
```

Periksa apakah service-service telah jalan:

```bash
docker-compose ps
```

Untuk mematikan container, jalankan perintah berikut:

```bash
docker-compose stop
```

Untuk menjalankan kembali container, jalankan perintah berikut:

```bash
docker-compose start
```

Composer install
```bash
docker-compose exec epuskesmas_5 composer install
```

Untuk akses aplikasi, http://localhost:8001
Untuk akses phpmyadmin, http://localhost:8002

Sebelum menjalankan migration, ubah env variable berikut (berlaku untuk semua env):
- DB_HOST_CENTER=mariadb

Untuk menjalankan migration, jalankan perintah berikut:

```bash
docker-compose exec epuskesmas_5 php artisan migrate --seed --force
```

```bash
docker-compose exec epuskesmas_5 php artisan migrate --seed --force --env={KODE_PKM}
```