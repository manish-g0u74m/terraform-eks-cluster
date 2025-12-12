# Create AWS EKS Cluster using Terraform

This project uses Terraform to create an Amazon EKS (Elastic Kubernetes Service) cluster on AWS. It sets up a VPC (Virtual Private Cloud), an EKS cluster, and a managed node group.

## Prerequisites

Before you begin, ensure you have the following installed:

*   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
*   [AWS CLI](https://aws.amazon.com/cli/)
*   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

You will also need an AWS account with the necessary permissions to create EKS clusters and related resources.

## Getting Started

1.  **Clone the repository:**
    ```sh
    git clone <repository-url>
    cd <repository-directory>
    ```

2.  **Configure AWS Credentials:**
    Make sure your AWS credentials are configured correctly. You can do this by running `aws configure` or by setting the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables.

3.  **Customize your configuration:**
    Update the `terraform.tfvars` file with your desired settings.

4.  **Initialize Terraform:**
    ```sh
    terraform init
    ```

5.  **Plan and Apply:**
    ```sh
    terraform plan
    terraform apply
    ```

    When prompted, type `yes` to create the resources.

## Architecture

This Terraform setup creates the following resources:

*   A new VPC with public and private subnets across three Availability Zones.
*   A NAT Gateway in the public subnet to allow instances in the private subnets to access the internet.
*   An EKS cluster in the VPC.
*   A managed node group of EC2 instances for running your containerized applications.

![alt text](/images/architecture.png)

## Terraform Configuration

### Input Variables

The following variables are defined in `variables.tf` and can be customized in `terraform.tfvars`:

| Name                      | Description                                        | Type          | Default     |
| ------------------------- | -------------------------------------------------- | ------------- | ----------- |
| `aws_region`              | The AWS region to create the resources in.         | `string`      | `us-west-2` |
| `vpc_cidr_block`          | The CIDR block for the VPC.                        | `string`      | `10.0.0.0/16` |
| `private_subnets`         | A list of CIDR blocks for the private subnets.     | `list(string)`| `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]` |
| `public_subnets`          | A list of CIDR blocks for the public subnets.      | `list(string)`| `["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]` |
| `environment`             | The environment name (e.g., "dev", "prod").        | `string`      | `"dev"`       |
| `eks_cluster_name`        | The name of the EKS cluster.                       | `string`      | `"manish-cluster"` |
| `eks_cluster_version`     | The Kubernetes version for the EKS cluster.        | `string`      | `"1.32"`      |
| `eks_node_ami_type`       | The AMI type for the EKS worker nodes.             | `string`      | `"AL2_x86_64"`|
| `key_pair_name`           | The name of the key pair to use for the worker nodes. | `string` | `"manish-keypair"`|
| `eks_node_instance_types` | The instance types for the EKS worker nodes.       | `list(string)`| `["t3.medium"]`|
| `eks_node_min_size`       | The minimum number of worker nodes.                | `number`      | `1`         |
| `eks_node_max_size`       | The maximum number of worker nodes.                | `number`      | `3`         |
| `eks_node_desired_size`   | The desired number of worker nodes.                | `number`      | `2`         |
| `eks_node_disk_size`      | The disk size in GB for the worker nodes.          | `number`      | `20`        |

### Outputs

The following outputs are defined in `outputs.tf`:

| Name                      | Description                                           |
| ------------------------- | ----------------------------------------------------- |
| `cluster_id`              | The ID of the EKS cluster.                            |
| `cluster_endpoint`        | The endpoint for the EKS control plane.               |
| `cluster_name`            | The name of the Kubernetes cluster.                   |
| `cluster_security_group_id`| The security group ID attached to the EKS cluster.   |
| `node_security_group_id`  | The security group ID attached to the EKS worker nodes. |

## Accessing the Cluster

After the `terraform apply` command completes, you can configure `kubectl` to communicate with your new cluster by running the following command:

```sh
aws eks update-kubeconfig --name $(terraform output -raw cluster_name) --region $(terraform output -raw region)
```

You can then test your connection to the cluster:
```sh
kubectl get nodes
```

## Cleaning Up

To destroy all the resources created by this project, run the following command:

```sh
terraform destroy
```

When prompted, type `yes` to confirm the deletion.