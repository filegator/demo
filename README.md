# FileGator Demo - Docker Image

## Docker build
`sudo docker build -t filegatordemo .`

## Docker run
`sudo docker run -it -p 8888:8080 filegatordemo`
visit: http://127.0.0.1:8888

## Google Cloud Build
`gcloud builds submit --tag gcr.io/[PROJECT_ID]/fgdemo .`

