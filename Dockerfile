FROM rust:1.96.1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    libdbus-1-dev \
    pkg-config \
    dbus \
    modemmanager \
    && rm -rf /var/lib/apt/lists/*

COPY Cargo.toml Cargo.lock ./
COPY mmrs ./mmrs

RUN cargo build -p mmrs --release && cargo build -p mmrs

CMD ["/bin/bash"]
