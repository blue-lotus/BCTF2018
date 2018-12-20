docker build -t wasm .
docker run -p "0.0.0.0:23333:23333" -d -t wasm
