FROM rust:1.96.1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    libdbus-1-dev \
    pkg-config \
    dbus \
    modemmanager \
    && rm -rf /var/lib/apt/lists/*

COPY Cargo.toml Cargo.lock ./
COPY src ./src

RUN cargo build --locked --release && cargo build --locked

CMD ["/bin/bash"]
