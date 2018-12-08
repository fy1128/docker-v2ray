FROM alpine:latest

RUN set -ex; \
	\
	apk add --no-cache --virtual .build-deps \
		curl ca-certificates \
	; \
	\
	mkdir /tmp/v2ray /usr/bin/v2ray /etc/v2ray; \
	cd /tmp/v2ray; \
	V2_VER="$(curl -s https://api.github.com/repos/v2ray/v2ray-core/releases/latest | grep 'tag_name' | cut -d\" -f4)"; \
	curl -L -H "Cache-Control: no-cache" -o "/tmp/v2ray/v2ray.zip" "https://github.com/v2ray/v2ray-core/releases/download/${V2_VER}/v2ray-linux-64.zip"; \
	unzip v2ray.zip; \
	for f in $(find . -type f -name "v2ray" -o -name "v2ctl" -o -name "geo*"); do cp -f $f /usr/bin/v2ray/; done; \
	mkdir /var/log/v2ray/;\
	chmod +x /usr/bin/v2ray/v2ctl; \
	chmod +x /usr/bin/v2ray/v2ray; \
	cp config.json /etc/v2ray/config.json; \
	rm -rf /tmp/v2ray; \
	apk add --no-cache --virtual .run-deps ca-certificates; \
	apk del .build-deps

ENV PATH /usr/bin/v2ray:$PATH

CMD ["v2ray", "-config=/etc/v2ray/config.json"]
