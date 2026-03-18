FROM debian:bookworm-slim

# Build Arguments
ARG COMMIT
ARG REPOSITORY
ARG REPOSITORY_URL
ARG EPICS_VERSION=R3.15.9
ARG ASYN_VERSION=R4-45
ARG CALC_VERSION=R3-7-5
ARG STREAM_VERSION=2.8.24
ARG BOOT_DIR=iocstreakcamera

# Install Essential Debian Modules and other deps
RUN set -ex; \
    apt-get update &&\
    apt-get install -y make build-essential &&\
    apt-get install -y --fix-missing --no-install-recommends \
        socat \
        vim \
        nano \
        procps \
        tzdata \
        wget \
        libreadline-dev \
        ca-certificates \
        procserv \
        git &&\
    ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localt

# EPICS Environment Variables
ENV EPICS_HOST_ARCH=linux-x86_64
ENV EPICS_CA_AUTO_ADDR_LIST=YES
ENV EPICS_IOC_CAPUTLOG_INET=0.0.0.0
ENV EPICS_IOC_CAPUTLOG_PORT=7012
ENV EPICS_IOC_LOG_INET=0.0.0.0
ENV EPICS_IOC_LOG_PORT=7011
ENV EPICS_BASE=/opt/epics-${EPICS_VERSION}/base
ENV EPICS_MODULES=/opt/epics-${EPICS_VERSION}/modules
ENV ASYN=${EPICS_MODULES}/asyn-{ASYN_VERSION}
ENV CALC=${EPICS_MODULES}/calc-${CALC_VERSION}
ENV STREAM=${EPICS_MODULES}/StreamDevice-${STREAM_VERSION}
ENV PATH=${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}

# --- EPICS Base ---
WORKDIR /opt
RUN mkdir /opt/epics-R${EPICS_VERSION} && \
    cd /opt/epics-R${EPICS_VERSION} && \
    wget --no-check-certificate https://epics-controls.org/download/base/base-${EPICS_VERSION}.tar.gz && \
    tar -xzvf base-${EPICS_VERSION}.tar.gz && \
    rm -rf base-${EPICS_VERSION}.tar.gz && \
    mv base-${EPICS_VERSION} base && \
    mkdir modules && \
    cd base && \
    make -j$(nproc)

WORKDIR ${EPICS_MODULES}
# --- Calc Support ---
RUN wget --no-check-certificate https://github.com/epics-modules/calc/archive/${CALC_VERSION}.tar.gz && \
    tar -xvzf ${CALC_VERSION}.tar.gz && \
    rm -f ${CALC_VERSION}.tar.gz && \
    cd ${CALC} && \
    sed -i -e '7,17s/^/#/' -e '20cEPICS_BASE='${EPICS_BASE} configure/RELEASE && \
    make -j$(nproc)

# --- Asyn Driver ---
RUN wget --no-check-certificate https://www.aps.anl.gov/epics/download/modules/asyn-${ASYN_VERSION}.tar.gz && \
    tar -xvzf asyn-${ASYN_VERSION}.tar.gz && \
    rm -f asyn-${ASYN_VERSION}.tar.gz && \
    cd ${ASYN} && \
    sed -i -e '3,4s/^/#/' -e '8,11s/^/#/' -e '14cEPICS_BASE='${EPICS_BASE} configure/RELEASE && \
    sed -i '/TIRPC/c\TIRPC=YES' configure/CONFIG_SITE && \
    make -j$(nproc)

# --- Stream Device ---
RUN wget --no-check-certificate https://github.com/paulscherrerinstitute/StreamDevice/archive/2.8.16.tar.gz && \
    tar -zxvf ${STREAM_VERSION}.tar.gz && \
    rm ${STREAM_VERSION}.tar.gz && \
    cd ${STREAM} && \
    sed -i -e '11,18s/^/#/' -e '21,22s/^/#/' -e '29,31s/^/#/' -e '20cASYN='${ASYN} -e '21cCALC='${CALC} -e '25cEPICS_BASE='${EPICS_BASE} configure/RELEASE && \
    make -j$(nproc)

# Install Power Measurement App
RUN git clone ${REPOSITORY_URL} /opt/${REPOSITORY} && \
    git config --global --add safe.directory /opt/${REPOSITORY}

WORKDIR /opt/${REPOSITORY}
RUN git fetch && \
    git checkout ${COMMIT} && \
    echo EPICS_BASE=${EPICS_BASE} > configure/RELEASE.local && \
    echo ASYN=${AUTOSAVE} >> configure/RELEASE.local && \
    echo CALC=${CALC} >> configure/RELEASE.local && \
    echo STREAM=${STREAM} >> configure/RELEASE.local && \
    make -j$(nproc) && \
    chmod -R +r+x /opt/${REPOSITORY}/iocBoot/${BOOT_DIR}

WORKDIR /opt/${REPOSITORY}/iocBoot/${BOOT_DIR}

ENTRYPOINT ["/bin/bash", "./runProcServ.sh"]
