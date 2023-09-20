# FileGator Read-Only Demo - Docker Image

Demo docker image for [FileGator](https://demo.filegator.io).

You can use `configuration.php` to tweak the app. See the [documentation](https://docs.filegator.io) for more info.

## Docker build
`docker build -t filegator/filegator:demo -f ./Dockerfile .`

## Docker run
`docker run -p 8888:8080 filegator/filegator:demo`

visit: http://127.0.0.1:8888




