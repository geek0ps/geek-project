# Use a minimal, secure base image
FROM ubuntu:18.04

# Set environment variables for Litecoin build paths
ENV LITECOIN_ROOT=/usr/src/litecoin \
    BDB_PREFIX=/usr/src/litecoin/db4 \
    BDB_VERSION=db-4.8.30.NC

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libtool \
    autotools-dev \
    automake \
    pkg-config \
    libssl-dev \
    libevent-dev \
    bsdmainutils \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-chrono-dev \
    libboost-program-options-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libminiupnpc-dev \
    libzmq3-dev \
    libfmt-dev \
    wget \
    git \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Download, verify, and install Berkeley DB
WORKDIR /usr/src
RUN git clone https://github.com/litecoin-project/litecoin.git
RUN mkdir -p $BDB_PREFIX \
    && wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz' \
    && echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef  db-4.8.30.NC.tar.gz' | sha256sum -c - \
    && tar -xzvf db-4.8.30.NC.tar.gz \
    && cd $BDB_VERSION/build_unix \
    && ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$BDB_PREFIX \
    && make install

# Copy local source code to container
WORKDIR $LITECOIN_ROOT

# Build Litecoin from source
RUN ./autogen.sh \
    && ./configure LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/" \
    CXXFLAGS="--param ggc-min-expand=1 --param ggc-min-heapsize=32768" --enable-upnp-default --without-gui \
    && make \
    && make install

# Strip the binaries to reduce image size
WORKDIR $LITECOIN_ROOT/src
RUN strip litecoind

# Create litecoin user for security
RUN groupadd -r litecoin && useradd -r -m -g litecoin litecoin

# Ensure that the litecoin user owns the source and compiled binaries
RUN chown -R litecoin:litecoin /usr/src/litecoin

# Switch to the non-root litecoin user
USER litecoin

# Set up Litecoin data directory
RUN mkdir -p /home/litecoin/.litecoin

# Expose the necessary P2P and RPC ports
EXPOSE 9333 9332

# Set the working directory to the litecoin home directory
WORKDIR /home/litecoin

# Start the Litecoin daemon
CMD ["litecoind", "-datadir=/home/litecoin/.litecoin"]
