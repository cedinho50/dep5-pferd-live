FROM python:3.12-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends ffmpeg ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && pip install --no-cache-dir --upgrade streamlink

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
