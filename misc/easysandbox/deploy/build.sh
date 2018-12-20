docker build -t sandbox .
docker run -p "0.0.0.0:23334:23334" -d -t sandbox
