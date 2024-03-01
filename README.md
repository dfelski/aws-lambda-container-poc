# AWS Lambda Container PoC

This is a small PoC to test AWS Lambda functions as containers.

The container located in `docker` directory provides an exmaple Python function to export a docker image using [skopeo](https://github.com/containers/skopeo) from a remote docker registry as a tar.gz file and story it in a S3 bucket.

# Local test
The local test is possible, but won't finish successfuyl due to the missing dependency to S3 buckets. But you can still see how everything works.

```
docker build -t lambda_test ./docker
docker run -p 8080:8080 lambda_test
curl "http://localhost:8080/2015-03-31/functions/function/invocations" -d '{"dockerImage":"nginx:latest"}'
```

# AWS deployment

First step: adjust `provider.tf` accordingly ;)

Use `terraform plan` to see what will happen and if your `provider.tf` setup is correct.
`terraform apply --auto-approve` deployes the AWS infrastructure. 

Check the output and call e.g.
```
curl -X POST <baseUrl>/<endpoint> -d '{"dockerImage":"nginx:latest"}'
```