Репозиторий для работы над домашними заданиями в рамках курса **"DevOps практики и инструменты"**

**Содержание:**
<a name="top"></a>  
1. [ДЗ № 12 - Docker контейнеры. Docker под капотом](#hw12)
2. [ДЗ № 13 - Docker образы. Микросервисы](#hw13) 
3. [ДЗ № 14 - Сетевое взаимодействие Docker контейнеров. Docker Compose. Тестирование образов](#hw14)
   
---
<a name="hw12"></a>
# Выполнено ДЗ № 12 - Docker контейнеры. Docker под капотом

 - [x] Основное ДЗ
 - [x] Задание с ⭐ Развертывание Docker и деплой контейнера в Yandex Cloud

## В процессе сделано:

1. Повторил известные мне команды Docker CLI
2. Собрал образ для приложения Reddit-App (пока монолит)
3. Ознакомился с депрекейтед уже docker-machine
4. Задеплоил при помощи docker-machine контейнер в инстансе Yandex Cloud

### Задание с ⭐ Развертывание Docker и деплой контейнера в Yandex Cloud

1. Подготовил с использованием Packer + Ansible provision образ в YC с установленным Docker.
2. Развернул инстансы с помощью Terraform, количество задается переменной, используется образ, подготовленный в п. 1. Инстансы доступны через Network Load Balancer.
3. Запустил контейнер на всех инстансах при помощи Ansible, хосты выбрал с использованием Dynamic Inventory.

Все конфигурационные файлы (Packer, Terraform и Ansible) см. [dockermonolith/infra](dockermonolith/infra)

Вывод Ansible:
```shell
$ ansible-playbook site.yml

PLAY [Install Docker] *******************************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************************
ok: [fhmate3ubd9j2adpicso.auto.internal]
ok: [fhm63ar6a27od5cu8cls.auto.internal]

TASK [Update and upgrade apt packages] **************************************************************************************************************************************************************************
ok: [fhmate3ubd9j2adpicso.auto.internal]
ok: [fhm63ar6a27od5cu8cls.auto.internal]

TASK [Install Docker dependencies] ******************************************************************************************************************************************************************************
ok: [fhmate3ubd9j2adpicso.auto.internal]
ok: [fhm63ar6a27od5cu8cls.auto.internal]

TASK [Add Docker repo key] **************************************************************************************************************************************************************************************
ok: [fhmate3ubd9j2adpicso.auto.internal]
ok: [fhm63ar6a27od5cu8cls.auto.internal]

TASK [Add Docker repository] ************************************************************************************************************************************************************************************
ok: [fhmate3ubd9j2adpicso.auto.internal]
ok: [fhm63ar6a27od5cu8cls.auto.internal]

TASK [Update and upgrade apt packages] **************************************************************************************************************************************************************************
ok: [fhmate3ubd9j2adpicso.auto.internal]
ok: [fhm63ar6a27od5cu8cls.auto.internal]

TASK [Docker install] *******************************************************************************************************************************************************************************************
ok: [fhmate3ubd9j2adpicso.auto.internal]
ok: [fhm63ar6a27od5cu8cls.auto.internal]

TASK [Add user to docker group] *********************************************************************************************************************************************************************************
ok: [fhmate3ubd9j2adpicso.auto.internal]
ok: [fhm63ar6a27od5cu8cls.auto.internal]

PLAY [Run Reddit-app container] *********************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************************
ok: [fhmate3ubd9j2adpicso.auto.internal]
ok: [fhm63ar6a27od5cu8cls.auto.internal]

TASK [Container run] ********************************************************************************************************************************************************************************************
--- before
+++ after
@@ -1,3 +1,3 @@
 {
-    "running": false
+    "running": true
 }

changed: [fhmate3ubd9j2adpicso.auto.internal]
--- before
+++ after
@@ -1,3 +1,3 @@
 {
-    "running": false
+    "running": true
 }

changed: [fhm63ar6a27od5cu8cls.auto.internal]

PLAY RECAP ******************************************************************************************************************************************************************************************************
fhm63ar6a27od5cu8cls.auto.internal : ok=10   changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
fhmate3ubd9j2adpicso.auto.internal : ok=10   changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Как запустить проект:

## Как проверить работоспособность:
---
<a name="hw13"></a>
# Выполнено ДЗ № 13 - Docker образы. Микросервисы

 - [x] Основное ДЗ
 - [x] Задание с ⭐ запуск с другими сетевыми алиасами
 - [x] Задание с ⭐ оптимизация размера образа

## В процессе сделано:

1. Переписал неоптимальные инструкции в предложенных Dockerfile.
2. Собрал образы для каждого микросервиса.
3. Запустил минкросервисы и убедился, что сайт работает корректно.

### Задание с ⭐ запуск с другими сетевыми алиасами

```shell
$ docker run -d --network=reddit -p 9292:9292 -e POST_SERVICE_HOST=post_app -e COMMENT_SERVICE_HOST=comment_app voitenkov/ui:2.0

$ docker run -d --network=reddit --network-alias=post_app -e POST_DATABASE_HOST=mongo_db voitenkov/post:1.0

$ docker run -d --network=reddit --network-alias=comment_app -e COMMENT_DATABASE_HOST=comment_db voitenkov/comment:1.0

$ docker run -d --network=reddit -p 9292:9292 -e POST_SERVICE_HOST=post_app -e COMMENT_SERVICE_HOST=comment_app voitenkov/ui:2.0


$ docker ps

CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS          PORTS                                       NAMES
c521a0143f69   voitenkov/ui:2.0        "puma"                   45 seconds ago   Up 44 seconds   0.0.0.0:9292->9292/tcp, :::9292->9292/tcp   trusting_kalam
aae24353bbb6   voitenkov/comment:1.0   "puma"                   2 minutes ago    Up 2 minutes                                                friendly_mcnulty
803861e5002b   voitenkov/post:1.0      "python3 post_app.py"    3 minutes ago    Up 3 minutes                                                interesting_wilbur
e22fb1e18d15   mongo:3.2               "docker-entrypoint.s…"   6 minutes ago    Up 6 minutes    27017/tcp                                   amazing_jennings

$ curl localhost:9292

<!DOCTYPE html>
<html lang='en'>
<head>
<meta charset='utf-8'>
<meta content='IE=Edge,chrome=1' http-equiv='X-UA-Compatible'>
<meta content='width=device-width, initial-scale=1.0' name='viewport'>
<title>Microservices Reddit :: All posts</title>
...
<a class='navbar-brand' href='/'>Microservices Reddit in  c521a0143f69 container</a>
<div class='navbar-collapse collapse navbar-responsive-collapse'></div>
```

### Задание с ⭐ оптимизация размера образа

Заменил образы на Alpine, разница налицо. UI 3.0 - заменил образ Ubuntu на Alpine, по другим образам я изначально прописал Alpine образы:

```shell
$ docker images
REPOSITORY                    TAG             IMAGE ID       CREATED              SIZE
voitenkov/ui                  3.0             abd2050e7ce0   7 seconds ago        297MB
voitenkov/ui                  2.0             b0cd99a1268e   19 hours ago         487MB
voitenkov/post                1.0             69881f7281a9   19 hours ago         121MB
voitenkov/comment             1.0             edcb89e74894   20 hours ago         294MB
mongo                         3.2             fb885d89ea5c   4 years ago          300MB
ruby                          2.2             6c8e6f9667b2   5 years ago          715MB
ruby                          2.2.10-alpine   d212148e08f7   5 years ago          107MB
python                        3.6.0-alpine    cb178ebbf0f2   6 years ago          88.6MB
```

## Как запустить проект:

## Как проверить работоспособность:

---
<a name="hw14"></a>
# Выполнено ДЗ № 14 - Сетевое взаимодействие Docker контейнеров. Docker Compose. Тестирование образов

 - [x] Основное ДЗ
 - [x] Задание с ⭐ Создайте docker-compose.override.yml для reddit проекта

## В процессе сделано:

1. Потренировался с настройкой сетевого взаимодействия контейнеров в Docker
2. Вспомнил как работать с Docker Compose

### Сетевое взамодействие контейнеров

```shell
docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig


$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED              STATUS              PORTS     NAMES
1194e2760984   nginx     "/docker-entrypoint.…"   About a minute ago   Up About a minute             interesting_snyder

$ docker run --network host -d nginx
1aad755a8132ac15343b82352dd5ea7caeb0dce6e033640583322a8f653ed898

$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS     NAMES
1aad755a8132   nginx     "/docker-entrypoint.…"   2 seconds ago   Up 2 seconds             amazing_chebyshev
1194e2760984   nginx     "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes             interesting_snyder

$ docker run --network host -d nginx
6110444caf0b6a0ee7af345a5c69fefee4086ef16536bca67f1841709e57e85b

$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS     NAMES
6110444caf0b   nginx     "/docker-entrypoint.…"   2 seconds ago   Up 1 second              xenodochial_benz
1194e2760984   nginx     "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes             interesting_snyder

$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS     NAMES
1194e2760984   nginx     "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes             interesting_snyder
```
Видно, что следующие контейнеры не могут запуститься, так как пытаются "сесть" на один и тот же порт.
   
### Задание с ⭐ Создайте docker-compose.override.yml для reddit проекта

Окончательный вариант с docker-compose.override.yml:
```shell
$ docker compose up
[+] Running 6/6
 ✔ Network back_net         Created                                                                                                                                                                         0.2s
 ✔ Network front_net        Created                                                                                                                                                                         0.1s
 ✔ Container src-post_db-1  Created                                                                                                                                                                         0.0s
 ✔ Container src-post-1     Created                                                                                                                                                                         0.0s
 ✔ Container src-comment-1  Created                                                                                                                                                                         0.0s
 ✔ Container src-ui-1       Created                                                                                                                                                                         0.0s
Attaching to src-comment-1, src-post-1, src-post_db-1, src-ui-1
src-post_db-1  | 2023-11-04T12:46:00.329+0000 I CONTROL  [initandlisten] MongoDB starting : pid=1 port=27017 dbpath=/data/db 64-bit host=f28f84709433
src-post_db-1  | 2023-11-04T12:46:00.329+0000 I CONTROL  [initandlisten] db version v3.2.21
src-post_db-1  | 2023-11-04T12:46:00.329+0000 I CONTROL  [initandlisten] git version: 1ab1010737145ba3761318508ff65ba74dfe8155
src-post_db-1  | 2023-11-04T12:46:00.329+0000 I CONTROL  [initandlisten] OpenSSL version: OpenSSL 1.0.1t  3 May 2016
...
src-ui-1       | [1] - Worker 0 (pid: 8) booted, phase: 0
src-ui-1       | [1] - Worker 1 (pid: 12) booted, phase: 0
src-comment-1  | * Listening on tcp://0.0.0.0:9292
```
Видим, что запущено 2 воркера, override сработал

## Как запустить проект:

## Как проверить работоспособность:

## PR checklist:
 - [x] Выставлен label с темой домашнего задания
