ARG AIRFLOW_VERSION=3.0.1

FROM apache/airflow:${AIRFLOW_VERSION}-python3.12

USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         build-essential \
         unixodbc-dev \
         libpq-dev \
         vim \
         unzip \
         git \
         telnet \
  && curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc \
  && curl https://packages.microsoft.com/config/debian/12/prod.list | tee /etc/apt/sources.list.d/mssql-release.list \
  && echo "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/mssql-release.list \
  && apt-get update -yqq \
  && ACCEPT_EULA=Y apt-get install -yqq msodbcsql17 \
  && sed -i '/\[openssl_init\]/a ssl_conf = ssl_configuration' /etc/ssl/openssl.cnf \
  && echo "[ssl_configuration]" >> /etc/ssl/openssl.cnf \
  && echo "system_default = tls_system_default" >> /etc/ssl/openssl.cnf \
  && echo "[tls_system_default]" >> /etc/ssl/openssl.cnf \
  && echo "MinProtocol = TLSv1" >> /etc/ssl/openssl.cnf \
  && echo "CipherString = DEFAULT@SECLEVEL=0" >> /etc/ssl/openssl.cnf \
  && curl -O http://acraiz.icpbrasil.gov.br/credenciadas/CertificadosAC-ICP-Brasil/ACcompactado.zip \
  && unzip ACcompactado.zip -d /usr/local/share/ca-certificates/ \
  && update-ca-certificates \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/man \
    /usr/share/doc \
    /usr/share/doc-base \
  && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
  && sed -i 's/^# pt_BR.UTF-8 UTF-8$/pt_BR.UTF-8 UTF-8/g' /etc/locale.gen \
  && locale-gen en_US.UTF-8 pt_BR.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
  && curl https://ssltools.digicert.com/chainTester/webservice/validatecerts/certificate?certKey=issuer.intermediate.cert.98&fileName=Thawte%20RSA%20CA%202018&fileExtension=txt >> /home/airflow/.local/lib/python3.12/site-packages/certifi/cacert.pem

USER airflow

COPY requirements.txt .

RUN pip install --no-cache-dir apache-airflow==${AIRFLOW_VERSION} -r requirements.txt
