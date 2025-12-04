# Base "VM-like" environment
FROM ubuntu:24.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update & install some useful tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        wget \
        git \
        vim \
        nano \
        python3 \
        python3-pip \
        python-is-python3 \
        ghostscript \
        unzip \
    && rm -rf /var/lib/apt/lists/*

RUN pip install requests nicegui==2.22.2 lxml markdown pypdf --break-system-packages

RUN mkdir -p /home/edipod \
    && cd /home/edipod \
    && wget https://github.com/rathindrasaran/rathindrasaran.github.io/raw/refs/heads/main/edi_gen_ai_8.zip \
    && unzip edi_gen_ai_8.zip \
    && rm edi_gen_ai_8.zip

RUN mkdir -p /home/edipod/tools \
    && cd /home/edipod/tools \
    && wget https://github.com/azoner/pyx12/archive/refs/heads/master.zip \
    && unzip *master.zip \
    && cd /home/edipod/tools/*-master \
    && python setup.py install

RUN cd /home/edipod/tools \
    && wget https://github.com/rathindrasaran/rathindrasaran.github.io/raw/refs/heads/main/maps-bkp.zip \
    && unzip maps-bkp.zip \
    && cd /home/edipod/tools/maps-bkp \
    && cp -f 837.5010.X224.A2.xml /usr/local/lib/python3.12/dist-packages/pyx12-3.0.0rc3-py3.12.egg/pyx12/map/837.5010.X224.A2.xml \
    && cp -f 837.5010.X222.A1.xml /usr/local/lib/python3.12/dist-packages/pyx12-3.0.0rc3-py3.12.egg/pyx12/map/837.5010.X222.A1.xml \
    && cp -f maps.xml /usr/local/lib/python3.12/dist-packages/pyx12-3.0.0rc3-py3.12.egg/pyx12/map/maps.xml \
    && cp -f 837.5010.X224.A2.xml /home/edipod/tools/pyx12-master/pyx12/map/837.5010.X224.A2.xml \
    && cp -f 837.5010.X222.A1.xml /home/edipod/tools/pyx12-master/pyx12/map/837.5010.X222.A1.xml \
    && cp -f maps.xml /home/edipod/tools/pyx12-master/pyx12/map/maps.xml \
    && cp -f py12.conf.xml /home/edipod/tools/pyx12-master/bin/py12.conf.xml \
    && cp -f x12file.py /usr/local/lib/python3.12/dist-packages/pyx12-3.0.0rc3-py3.12.egg/pyx12/x12file.py

EXPOSE 8080

CMD ["python", "/home/edipod/edi_gen_ai/main.py"]
