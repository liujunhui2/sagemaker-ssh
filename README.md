# sagemaker-ssh
AWS SageMaker TrainingJob container allowing SSH connection

## How to use
### Prerequisites
- You need to have a jump host (e.g. EC2 instance) with an SSH server
- Make sure you have aws cli and docker installed
### Build and push docker container image
- Clone the repository
- Change to the directory and build the container with docker
```
docker build -t sagemaker-ssh .
```
- Create an repository "sagemaker-ssh" in AWS ECR (Elastic Container Registry)
- Tag the container you just built
```
docker tag sagemaker-ssh:latest <put your ecr registry here>/sagemaker-ssh:latest
```
- Login to your ECR. Your can also find the login instruction in the ECR console
```
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <put your ecr registry here>
```
- Push your container to ECR
```
docker push <put your ecr registry here>/sagemaker-ssh:latest
```
### Create a SageMaker training job
- Create a training job using "Your own algorithm container in ECR" and specify the previous created repository.
- Provide your SSH jump host IP and SSH key (base64 encoded) in hyper parameters. The following is an example
```
{
        "SSH_HOST": "10.0.14.242",
        "SSH_KEY_BASE64": "EXAMPLE1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBcFh3dDRxVzE1bkVJcEFpbjF6aVd5YzVaMTdLQ3ZpMFUvajhCWXAvblBwdmpDZXB5CkwwSmtHREZueFRycVp1WnQxSjVnRzMxQmY0cDJoUFhvczZEU2x4V2dMSjc1UGR3V3JRdDZId2NMY3F0TldTenUKV2hvMU5xbmNFbDBtYXJSa0tYK1RTSFJLdU9QcWF3OG5oMGJQL1paTVc4NG05MEVWY2J5MzZ4eUJwMzUvc1hibjhPWGdZQnl6NWhicisvV1d4Q3VqZGMKY3NMbTUvWUhhN0JLUnNuSno1WmhFM2NSNERQTlRrWjRzMnNqL0hUTEkyNXZYMmdHbmtqNzlpbXh3T0IrTGlFQwpFeDMwdmF1Q2NsU1lvM0xnWStMZjRZcENaOE4rWjBlWTREUUoyNEhhYkdETG9Pc0VUN0xKCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg=="
}
```
- (optional but recommended) Add VPC connection to your training job if your jump host is located in a VPC
- When the training job status becomes "training", you can ssh into the container in the jumphost. Password is default to aws.
```
ssh -p 2222 aws@127.0.0.1
```
### Trouble shooting
- Check training job log for potential error messages.
- Make sure your jump host IP is reachable from the training job
