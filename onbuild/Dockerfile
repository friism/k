FROM friism/k:3.10.0

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD ADD . /usr/src/app/
ONBUILD RUN kpm restore

