# FileGator Read-Only Demo - Docker Image

Demo docker image for [FileGator](https://filegator.io).

You can use `configuration.php` to tweak the app. See the [documentation](https://docs.filegator.io) for more info.

## Docker build
`sudo docker build -t filegatordemo .`

## Docker run
`sudo docker run -it -p 8888:8080 filegatordemo`

visit: http://127.0.0.1:8888

## Google Cloud
You can build and upload this demo to Google container registry and deploy it using [Cloud Run](https://cloud.google.com/run/)

`gcloud builds submit --tag gcr.io/[PROJECT_ID]/fgdemo .`



