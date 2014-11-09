FROM mono:3.10
MAINTAINER Michael Friis <friism@gmail.com>

RUN apt-get update \
        && apt-get install -y \
		unzip \
		python \
		gyp \
		gcc \
		make \
		g++ \
		screen
        && rm -rf /var/lib/apt/lists/*

# kestrel requires this version of libuv, so compile it
# from: https://gist.github.com/lodejard/c4260f246b1b0182466c
RUN mkdir /usr/src/libuv
WORKDIR /usr/src/libuv
RUN curl -SL "http://dist.libuv.org/dist/v1.0.0-rc1/libuv-v1.0.0-rc1.tar.gz" | tar -xz --strip-components=1
RUN ./gyp_uv.py -f make -Duv_library=shared_library
RUN make -C out
RUN cp out/Debug/lib.target/libuv.so /usr/lib/libuv.so.1.0.0-rc1
RUN ln -s libuv.so.1.0.0-rc1 /usr/lib/libuv.so.1
WORKDIR	/
RUN rm -rf /usr/src/libuv

# only very recent versions of kestrel will run on Linux, so use this package feed
ENV KRE_FEED https://www.myget.org/F/aspnetvnext/api/v2

# from: http://msopentech.com/blog/2014/11/07/creating-asp-net-vnext-docker-container-using-mono-2/
RUN curl -s https://raw.githubusercontent.com/aspnet/Home/master/kvminstall.sh | sh \
	&& bash -c "source /root/.kre/kvm/kvm.sh \
		&& kvm upgrade \
		&& kvm alias default | xargs -i ln -s /root/.kre/packages/{} /root/.kre/packages/default"

ENV PATH $PATH:/root/.kre/packages/default/bin
