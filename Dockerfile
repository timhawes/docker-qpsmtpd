FROM debian:stretch

ENV QPSMTPD_VERSION 0.96
ENV QPSMTPD_SHA256 596ed98f7e8fe35c535e44dbecf1820cc12e9bf3c9d319327b6867e379e49801

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates wget perl libmailtools-perl libnet-dns-perl \
    && rm -r /var/lib/apt/lists/* \
    && cd /usr/src \
    && echo ${QPSMTPD_SHA256} v${QPSMTPD_VERSION}.tar.gz >SHA256SUMS \
    && wget https://github.com/smtpd/qpsmtpd/archive/v${QPSMTPD_VERSION}.tar.gz \
    && sha256sum -c SHA256SUMS \
    && tar xfz v${QPSMTPD_VERSION}.tar.gz -C /srv \
    && rm SHA256SUMS v${QPSMTPD_VERSION}.tar.gz \
    && mv /srv/qpsmtpd-${QPSMTPD_VERSION} /srv/qpsmtpd \
    && useradd -r -M -d /var/spool/smtpd smtpd \
    && mkdir -p /var/spool/qpsmtpd/tmp \
    && chown -R root:root /srv/qpsmtpd \
    && chown -R smtpd:smtpd /var/spool/qpsmtpd \
    && chmod 700 /var/spool/qpsmtpd/tmp

COPY entrypoint.sh /entrypoint.sh

ENV HOME /var/spool/qpsmtpd
WORKDIR /srv/qpsmtpd
CMD ["/entrypoint.sh"]
EXPOSE 25
