# deploy_it

This repository contains the code for the exercises contained in the `deploy_it` project proposed by Pix4d as a technical interview.

Progress through the different exercises is tagged with `up_to_{exercise}` tags so it is easier to review the code and the progress.

## Notes

### Exercise 2

Although I went through the different exercises in the [Modules section](https://learn.hashicorp.com/collections/terraform/modules) section, no code is included in this repository as the code was already provided in the documentation.

### Exercise 3

To fetch the AMI of the current Ubuntu Server 18.04 I used the aws CLI with the following query:

```
$ aws ec2 describe-images \
    --region eu-west-3 \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-????????" "Name=state,Values=available" \
    --query "reverse(sort_by(Images, &CreationDate))[:1].ImageId" \
    --output text
ami-089d839e690b09b28
```

This exercise uses Ansible to provision the web server with NGINX and a website referenced by a git repository. Although this is not required for the exercise and it could be achieved through a `remote-exec`, it is more convenient as new things are required. It also allows to reprovision the server at any time by using `ansible-playbook`.
