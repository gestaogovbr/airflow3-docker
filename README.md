# Airflow 3 da CGINF/SEGES

Neste repositório estão os códigos e instruções da instalação e
configuração do ambiente Airflow 3 utilizado pelos desenvolvedores da
SEGES.

Este ambiente é similar ao de produção: utiliza a mesma versão do
Airflow, instala os mesmo módulos extras do Airflow e as mesmas
dependências python. Isso possibilita que o desenvolvimento seja
realizado totalmente em ambiente local de forma compatível com o
ambiente produção.

Este repositório foi adaptado a partir da solução oficial da Apache
Airflow disponível em
https://airflow.apache.org/docs/apache-airflow/stable/start/docker.html.

## 1. SETUP

- [Docs Airflow Docker](https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html)
- [Docs Airflow Docker Image](https://github.com/apache/airflow/tree/main/docker-stack-docs)

### 1.1. Instalar Docker

- [Install Docker](https://docs.docker.com/get-docker/)

### 1.2. Clonar Airflow 3 Docker

> Este próprio repo. Pular se já estiver feito.

```shell
git clone https://github.com/gestaogovbr/airflow3-docker.git
```

### 1.3. Clonar DAGs e Plugins

A partir do mesmo diretório que o airflow3-docker foi clonado, realizar
os clones dos repositórios que contém código fonte das DAGs e Plugins.

> Por que a partir do mesmo diretório? Porque é a localização que o
> [docker-compose.yml](/docker-compose.yml#L26) espera que o código das
> DAGs e Plugins estejam para mapear no container do Airflow.

> [!NOTE]
> Os comandos fazem clone da branch `airflow3-migration` porque o Airflow 3
> ainda não é ambiente de produção (senão seria da branch `main`)

#### Airflow DAGs

```bash
git clone -b airflow3-migration https://github.com/gestaogovbr/airflow-dags.git
```

#### Airflow DAGS DELOG

```bash
git clone -b airflow3-migration https://github.com/gestaogovbr/airflow-dags-delog.git
```

#### Airflow DAGS DETRU

```bash
git clone -b airflow3-migration https://github.com/gestaogovbr/airflow-dags-detru.git
```

#### Airflow Commons

```bash
git clone -b airflow3-migration https://github.com/gestaogovbr/airflow_commons.git
```

#### FastETL

```bash
git clone -b airflow3-migration https://github.com/gestaogovbr/FastETL.git
```

#### Ro-Dou

```bash
git clone -b airflow3-migration https://github.com/gestaogovbr/Ro-dou.git
```

## 2. RUNNING

### 2.1. Subir

```bash
# no mesmo dir em que está o arquivo docker-compose.yml (/airflow3-docker)
docker compose up
```

**Airflow UI**

- `url`: `localhost:8080`
- `user`: `airflow`
- `password`: `airflow`

### 2.2. Descer

```bash
# no mesmo dir em que está o arquivo docker-compose.yml (/airflow3-docker)
docker compose up
```

## 3. DEVELOPING

### 3.1. Instalando nova biblioteca

- [Docs Airflow Docker Build](https://airflow.apache.org/docs/docker-stack/build.html)
- [Docs Airflow Providers and Extras](https://airflow.apache.org/docs/apache-airflow/stable/extra-packages-ref.html)

1. Edite o arquivo [`requirements.txt`](/requirements.txt)
2. Próxima vez que iniciar o ambiente adicione `--build`

```bash
docker compose up --build
```

### 3.2. Executando comandos dentro do container do Airflow, como o airflow cli

- [Docs Airflow CLI](https://airflow.apache.org/docs/apache-airflow/stable/cli-and-env-variables-ref.html)

```bash
docker exec -it worker /bin/bash
```
