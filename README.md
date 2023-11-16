Репозиторий для работы над домашними заданиями в рамках курса **"DevOps практики и инструменты"**

**Содержание:**
<a name="top"></a>  
1. [ДЗ № 12 - Docker контейнеры. Docker под капотом](#hw12)
2. [ДЗ № 13 - Docker образы. Микросервисы](#hw13) 
3. [ДЗ № 14 - Сетевое взаимодействие Docker контейнеров. Docker Compose. Тестирование образов](#hw14)
4. [ДЗ № 15 - Устройство Gitlab CI. Построение процесса непрерывной интеграции](#hw15)
5. [ДЗ № 16 - Введение в мониторинг. Модели и принципы работы систем мониторинга](#hw16)
6. [ДЗ № 18 - Введение в Kubernetes #1](#hw18)
7. [ДЗ № 19 - Основные модели безопасности и контроллеры в Kubernetes](#hw19)
   
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
   
### Docker-compose

Задание: узнайте как образуется базовое имя проекта. Можно ли его задать? Если можно то как?
Ответ: базовое имя проекта формируется из имени каталога, в котором размещен проект, можно задать переменной PROJECT_NAME, которую можно прописать в файле .env.

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

---
<a name="hw15"></a>
# Выполнено ДЗ № 15 - Устройство Gitlab CI. Построение процесса непрерывной интеграции

 - [x] Основное ДЗ
 - [x] Задание с ⭐ Автоматизация развёртывания GitLab (по желанию)
 - [x] Задание с ⭐ Запуск reddit в контейнере (по желанию)
 - [x] Задание с ⭐ Автоматизация развёртывания GitLab Runner (по желанию)
 - [ ] Задание с ⭐ Настройка оповещений в Slack (по желанию)

## В процессе сделано:

1. Подготовил инсталляцию Gitlab CI CE
2. Подготовил репозиторий с кодом приложения
3. Описал для приложения этапы пайплайна
4. Определил окружения, включая динамические

### Задание с ⭐ Автоматизация развёртывания GitLab (по желанию)

Docker установил через userdata Cloud-init Terraform'ом.
Gitlab запустил с использованием модуля Ansible docker_container, см: (gitlab-ci/infra/run_container.yml)[gitlab-ci/infra/run_container.yml].

Результат:
```shell
$ ansible-playbook run_container.yml

PLAY [Run Gitlab container] *************************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************************
ok: [gitlab.ru-central1.internal]

TASK [Container run] ********************************************************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
-    "exists": false,
-    "running": false
+    "exists": true,
+    "running": true
 }

changed: [gitlab.ru-central1.internal]

PLAY RECAP ******************************************************************************************************************************************************************************************************
gitlab.ru-central1.internal : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

### Задание с ⭐ Запуск reddit в контейнере (по желанию)

Доработал build_job:
```shell
build_job:
  stage: build
  image: docker:20.10.12-dind-rootless
  before_script:
    - until docker info; do sleep 1; done
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - cd reddit
    - >
      docker build
      --tag $CI_REGISTRY_IMAGE/reddit-app:0.0.$CI_PIPELINE_IID
      --tag $CI_REGISTRY_IMAGE/reddit-app:latest
      .
    - docker push $CI_REGISTRY_IMAGE/reddit-app:0.0.$CI_PIPELINE_IID
    - docker push $CI_REGISTRY_IMAGE/reddit-app:latest
```
и branch_review задание: 
```shell
branch_review:
  stage: review
  image: alpine:3.15.0
  environment:
    name: branch/$CI_COMMIT_REF_NAME
    url: http://$CI_ENVIRONMENT_SLUG.example.com
  only:
    - branches
  except:
    - main
  before_script:
    - apk add openssh-client bash
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - echo "$SSH_KNOWN_HOSTS" >> ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts
  script:
    - ssh ${DEV_USER}@${DEV_HOST}
      "setsid /bin/bash -s " < ./reddit/deploy.sh
```

### Задание с ⭐ Автоматизация развёртывания GitLab Runner (по желанию)

GitLab Runner уже установлен через userdata Cloud-init Terraform'ом.

### Задание с ⭐ Настройка оповещений в Slack (по желанию)

Слака на курсе и в РФ нет, интегрироваться не с чем. Когда был доступен, дергал web-hook прямо из пайплайна.

## Как запустить проект:

## Как проверить работоспособность:

---
<a name="hw16"></a>
# Выполнено ДЗ № 16 - Введение в мониторинг. Модели и принципы работы систем мониторинга

 - [x] Основное ДЗ
 - [x] Задание с ⭐ Добавьте в Prometheus мониторинг MongoDB с использованием необходимого экспортера
 - [x] Задание с ⭐ Добавьте в Prometheus мониторинг сервисов comment, post, ui с помощью **blackbox-exporter**
 - [x] Задание с ⭐ Напишите Makefile , который в минимальном варианте умеет билдить и пушить Docker-образы

## В процессе сделано:

1. Prometheus: запуск, конфигурация, знакомство с Web UI
2. Мониторинг состояния микросервисов
3. Сбор метрик хоста с использованием экспортера

Ссылка реджистри с собранными образами: [https://hub.docker.com/u/voitenkov](https://hub.docker.com/u/voitenkov)

### Задание с ⭐ Добавьте в Prometheus мониторинг MongoDB с использованием необходимого экспортера

Добавляем новый сервис:
```shell
  mongodb-exporter:
    container_name: mongodb-exporter
    image: percona/mongodb_exporter:0.30.0
    ports:
      - '9216:9216'
    command:
      - '--mongodb.uri=mongodb://mongo_db:27017'
      - '--compatible-mode'
      - '--mongodb.direct-connect=true'
    networks:
      - front_net
      - back_net
    depends_on:
      - mongo_db
```

### Задание с ⭐ Добавьте в Prometheus мониторинг сервисов comment, post, ui с помощью **blackbox-exporter**

Собираем образ с конфигом: 
```shell
modules:
  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
      valid_status_codes: []
      method: GET
      follow_redirects: false
```
Добавляем новые таргеты в конфиг promethetus и его тоже пересобираем:
```shell
  - job_name: 'blackbox'
    metrics_path: /metrics
    params:
      module: [http_2xx]
    static_configs:
      - targets:
        - http://ui:9292
        - http://comment:9292
        - http://post:9292
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackbox-exporter:9115
```
и добавляем новый сервис:
```shell
  blackbox-exporter:
    container_name: blackbox-exporter
    image: ${USERNAME}/blackbox-exporter:latest
    ports:
      - '9115:9115/tcp'
    networks:
      - back_net
      - front_net
```

В результате получаем:
```shell
$ docker compose up -d
[+] Running 10/10
 ✔ Network front_net            Created                                                                                                                                                                     0.1s
 ✔ Network back_net             Created                                                                                                                                                                     0.1s
 ✔ Container blackbox-exporter  Started                                                                                                                                                                     1.9s
 ✔ Container mongodb            Started                                                                                                                                                                     1.5s
 ✔ Container node-exporter      Started                                                                                                                                                                     1.9s
 ✔ Container prometheus         Started                                                                                                                                                                     2.1s
 ✔ Container comment            Started                                                                                                                                                                     3.4s
 ✔ Container mongodb-exporter   Started                                                                                                                                                                     3.3s
 ✔ Container post               Started                                                                                                                                                                     3.3s
 ✔ Container ui                 Started                                                                                                                                                                     3.8s
$ docker ps
CONTAINER ID   IMAGE                                COMMAND                  CREATED         STATUS         PORTS                                       NAMES
2ba9f1010c8b   voitenkov/ui:latest                  "puma"                   8 seconds ago   Up 4 seconds   0.0.0.0:9292->9292/tcp, :::9292->9292/tcp   ui
3bf89aec50d8   voitenkov/post:latest                "python3 post_app.py"    8 seconds ago   Up 5 seconds                                               post
9a6c066785c6   voitenkov/comment:latest             "puma"                   8 seconds ago   Up 5 seconds                                               comment
b5ca54b1b09a   percona/mongodb_exporter:0.30.0      "/mongodb_exporter -…"   8 seconds ago   Up 5 seconds   0.0.0.0:9216->9216/tcp, :::9216->9216/tcp   mongodb-exporter
a687a7fcdc55   voitenkov/blackbox-exporter:latest   "/bin/blackbox_expor…"   8 seconds ago   Up 6 seconds   0.0.0.0:9115->9115/tcp, :::9115->9115/tcp   blackbox-exporter
5a5003218409   prom/node-exporter:v0.15.2           "/bin/node_exporter …"   8 seconds ago   Up 6 seconds   9100/tcp                                    node-exporter
c805ecfd14fb   voitenkov/prometheus:latest          "/bin/prometheus --c…"   8 seconds ago   Up 6 seconds   0.0.0.0:9090->9090/tcp, :::9090->9090/tcp   prometheus
4a9771672a61   mongo:3.2                            "docker-entrypoint.s…"   8 seconds ago   Up 7 seconds   27017/tcp                                   mongodb
```
Prometheus в окончательном варианте:

![Prometheus](/images/hw22-prometheus.png) 


### Задание с ⭐ Напишите Makefile , который в минимальном варианте умеет билдить и пушить Docker-образы

Makefile см. в [monitoring/Makefile](monitoring/Makefile)

## Как запустить проект:

## Как проверить работоспособность:

---
<a name="hw18"></a>
# Выполнено ДЗ № 18 - Введение в Kubernetes #1

 - [x] Основное ДЗ
 - [x] Задание с ⭐ Опишите установку кластера k8s с помощью terraform и ansible

## В процессе сделано:

1. Разобрал на практике все компоненты Kubernetes, развернуть их вручную используя kubeadm
2. Ознакомился с описанием основных примитивов нашего приложения и его дальнейшим запуском в Kubernetes

Развернул кластер K8s с использованием **kubeadm**:
```shell
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --upload-certs --kubernetes-version=v1.28.0 --ignore-preflight-errors=Mem
sudo kubeadm join 192.168.10.8:6443 --token ij2uef.bi2rn2dyhilz401e --discovery-token-ca-cert-hash sha256:216c05cc3bdc07b39cc6fa245b1ec5388111046a2e70520202503b64e3b9edb3 
```

Установил CALICO:
```shell
export CALICO_IPV4POOL_CIDR=10.244.0.0/16
wget https://projectcalico.docs.tigera.io/manifests/calico.yaml
sed -i -r -e 's/^([ ]+)# (- name: CALICO_IPV4POOL_CIDR)$\n/\1\2\n\1  value: "10.244.0.0\/16"/g' calico.yaml
kubectl apply -f calico.yaml
```

Кластер работоспособен:
```shell
NAME     STATUS   ROLES           AGE     VERSION
kuber1   Ready    control-plane   18m     v1.28.0
kuber2   Ready    <none>          6m40s   v1.28.0
```
Задеплоил поды:
```shell
$ kubectl apply -f reddit
````
Приложение устновлено:
```shell
$ kubectl get all -A
NAMESPACE     NAME                                           READY   STATUS    RESTARTS   AGE
default       pod/comment-7c97c4589f-wbgzt                   1/1     Running   0          5m27s
default       pod/mongo-58f4cf4c5f-r9hqz                     0/1     Pending   0          5m27s
default       pod/mongo-5f649fdb6d-thcrp                     0/1     Pending   0          62s
default       pod/post-76c769dbbd-g4b68                      1/1     Running   0          5m27s
default       pod/ui-6c584b986c-frlc5                        1/1     Running   0          5m27s
kube-system   pod/calico-kube-controllers-7ddc4f45bc-sw7d9   1/1     Running   0          11m
kube-system   pod/calico-node-rb7q5                          1/1     Running   0          11m
kube-system   pod/calico-node-rck8k                          1/1     Running   0          11m
kube-system   pod/coredns-5dd5756b68-7xlfl                   1/1     Running   0          28m
kube-system   pod/coredns-5dd5756b68-hnnd9                   1/1     Running   0          28m
kube-system   pod/etcd-kuber1                                1/1     Running   0          28m
kube-system   pod/kube-apiserver-kuber1                      1/1     Running   0          28m
kube-system   pod/kube-controller-manager-kuber1             1/1     Running   0          28m
kube-system   pod/kube-proxy-cnxwx                           1/1     Running   0          28m
kube-system   pod/kube-proxy-p8q45                           1/1     Running   0          16m
kube-system   pod/kube-scheduler-kuber1                      1/1     Running   0          28m
```

### Задание с ⭐ Опишите установку кластера k8s с помощью terraform и ansible

Для установки и подготовки виртуалок к устновке Kubernetes использовал Terraform + Userdata файл CloudInit.
Писать отдельную роль Ansible только для kubeadm init и join не стал. Для этого есть уже **Kubespray**.

## Как запустить проект:

## Как проверить работоспособность:

---
<a name="hw19"></a>
# Выполнено ДЗ № 19 - Основные модели безопасности и контроллеры в Kubernetes

 - [x] Основное ДЗ
 - [x] Задание с ⭐ Разверните Kubernetes-кластер в Yandex cloud с помощью Terraform
 - [x] Задание с ⭐ Создайте YAML-манифесты для описания созданных сущностей для включения dashboard
       
## В процессе сделано:

1. Развернул локальное окружение для работы с Kubernetes (Minikube)
2. Развернул Kubernetes в Yandex Cloud
3. Запустил Reddit в Kubernetes

Приложение успешно запустилось в Yandex Cloud Managed Kubernetes:

```shell
$ k get all -n dev
NAME                           READY   STATUS    RESTARTS   AGE
pod/comment-858c5c7d76-z82pt   1/1     Running   0          5m43s
pod/mongo-f474f9d56-mm4kg      1/1     Running   0          6m1s
pod/post-67856b8bd6-bw4rc      1/1     Running   0          6m
pod/ui-7d6fbbfc78-4rzcz        1/1     Running   0          5m59s
pod/ui-7d6fbbfc78-cbnv6        1/1     Running   0          5m59s
pod/ui-7d6fbbfc78-n4z6j        1/1     Running   0          5m59s

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
service/comment      ClusterIP   10.112.227.255   <none>        9292/TCP       5m43s
service/comment-db   ClusterIP   10.112.136.108   <none>        27017/TCP      5m43s
service/mongodb      ClusterIP   10.112.143.229   <none>        27017/TCP      6m
service/post         ClusterIP   10.112.226.109   <none>        5000/TCP       6m
service/post-db      ClusterIP   10.112.216.77    <none>        27017/TCP      6m
service/ui           NodePort    10.112.168.1     <none>        80:32092/TCP   5m59s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/comment   1/1     1            1           5m43s
deployment.apps/mongo     1/1     1            1           6m1s
deployment.apps/post      1/1     1            1           6m
deployment.apps/ui        3/3     3            3           5m59s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/comment-858c5c7d76   1         1         1       5m43s
replicaset.apps/mongo-f474f9d56      1         1         1       6m1s
replicaset.apps/post-67856b8bd6      1         1         1       6m
replicaset.apps/ui-7d6fbbfc78        3         3         3       5m59s
```

![Reddit in K8s](/images/hw19-reddit.png) 

### Задание с ⭐ Разверните Kubernetes-кластер в Yandex cloud с помощью Terraform

Давно уже в YC все разворачиваю исключительно Терраформом.  см. в [kubernetes/infra](kubernetes/infra)

### Задание с ⭐ Создайте YAML-манифесты для описания созданных сущностей для включения dashboard

Манифесты для Dashbord см. [kubernetes/dashboard](kubernetes/dashboard)

## Как запустить проект:

## Как проверить работоспособность:

## PR checklist:
 - [x] Выставлен label с темой домашнего задания
