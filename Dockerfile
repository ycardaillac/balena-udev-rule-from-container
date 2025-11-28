FROM alpine:latest

COPY 48-usb-hid.rules /etc/udev/rules.d/48-usb-hid.rules

COPY idle.sh /usr/src/scripts/idle.sh
RUN chmod a+x /usr/src/scripts/idle.sh

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

RUN apk add util-linux
RUN apk add bash
RUN apk add eudev


CMD [ "/bin/bash", "/usr/src/scripts/idle.sh" ]
