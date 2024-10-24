
# Terraform EKS Cluster Setup

This repository contains a Terraform configuration for provisioning an Amazon EKS (Elastic Kubernetes Service) cluster with associated networking resources on AWS. This setup includes a VPC, public and private subnets, and an EKS cluster with a managed node group.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Usage](#usage)
- [Accessing the EKS Cluster](#accessing-the-eks-cluster)
- [Accessing Grafana](#accessing-grafana)
- [Outputs](#outputs)
- [License](#license)

## Prerequisites

Before you begin, ensure you have the following installed on your local machine:

1. **Terraform**: You can download Terraform from [Terraform's official website](https://www.terraform.io/downloads.html).
2. **AWS CLI**: Follow the installation instructions on the [AWS CLI page](https://aws.amazon.com/cli/).
3. **kubectl**: Install the Kubernetes command-line tool from the [Kubernetes website](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
4. (Optional) **AWS IAM Authenticator**: Required for older AWS CLI versions. Check the [GitHub releases page](https://github.com/kubernetes-sigs/aws-iam-authenticator/releases).

## Configuration

### Variables

The following variables can be configured in the `terraform.tfvars` file:

```hcl
region         = "eu-central-1"
cluster_name   = "mywebpage-cluster"
vpc_name       = "mywebpage-cluster-VPC"
vpc_cidr       = "10.1.0.0/16"   # CIDR range for the VPC
azs            = ["eu-central-1a", "eu-central-1b"]
public_subnets = ["10.1.1.0/24", "10.1.2.0/24"]  # CIDR for public subnets
private_subnets = ["10.1.3.0/24", "10.1.4.0/24"] # CIDR for private subnets
min_size       = 1
max_size       = 1
desired_size   = 1
instance_types = ["t3.medium"]
capacity_type  = "SPOT"
tags           = {
  Example = "mywebpage-cluster"
}
```

### File Structure

The directory structure of the Terraform configuration is as follows:

```
/terraform-eks-cluster
│
├── main.tf                # Main Terraform configuration file
├── provider.tf            # Provider configuration file
├── variables.tf           # Variable definitions
├── terraform.tfvars       # Variable values
├── outputs.tf             # Outputs of the Terraform configuration
└── README.md 
```

## Usage

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/hashicorp/learn-terraform-provision-eks-cluster.git
   cd learn-terraform-provision-eks-cluster
   ```

2. **Initialize Terraform**:

   This command will download the necessary providers.

   ```bash
   terraform init
   ```

3. **Plan the Infrastructure**:

   Review the infrastructure changes Terraform will make.

   ```bash
   terraform plan
   ```

4. **Apply the Configuration**:

   Apply the changes to create the EKS cluster and associated resources.

   ```bash
   terraform apply
   ```

   Type `yes` when prompted to confirm.

# Accessing the EKS Cluster

Once the EKS cluster is provisioned, you can access it using `kubectl`. Follow these steps:

1. **Update kubeconfig**:

   Run the following command to configure your `kubectl` context. Replace `<your-cluster-name>` with the name of your EKS cluster:

   ```bash
   aws eks update-kubeconfig --name mywebpage-cluster --region eu-central-1
   ```

2. **Verify the Cluster Connection**:

   Check the nodes in your EKS cluster to confirm that the connection is successful:

   ```bash
   kubectl get nodes
   ```
# Deploying Prometheus and Grafana

To deploy Prometheus and Grafana on your EKS cluster, follow these steps:

1. **Add the Helm Stable Charts**:

   ```bash
   helm repo add stable https://charts.helm.sh/stable
   ```

2. **Add Prometheus Helm Repo**:

   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   ```

3. **Create Prometheus Namespace**:

   ```bash
   kubectl create namespace monitoring
   ```

4. **Install Kube-Prometheus Stack**:

   ```bash
   helm install stable prometheus-community/kube-prometheus-stack -n monitoring
   ```

5. **Edit the Prometheus Service to Make it LoadBalancer**:

   ```bash
   kubectl edit svc stable-kube-prometheus-sta-prometheus -n monitoring
   ```
   Change the service type from `ClusterIP` to `LoadBalancer` and save the changes:
   ```yaml
   spec:
     type: LoadBalancer
   ```

6. **Edit the Grafana Service to Change it to LoadBalancer**:

   ```bash
   kubectl edit svc stable-grafana -n monitoring
   ```
   Change the service type from `ClusterIP` to `LoadBalancer` and save the changes:
   ```yaml
   spec:
     type: LoadBalancer
   ```


### Steps to Access Prometheus and Grafana:

1. **Open Prometheus in a Web Browser**:

    Visit `http://<EXTERNAL-IP>:9090` in your web browser to access the Grafana dashboard.

2. **Open Grafana in a Web Browser**:

   Visit `http://<EXTERNAL-IP> in your web browser to access the Grafana dashboard.

3. **Log In**:

   Use the following credentials to log in:

   - Username: `admin`
   - Password: `prom-operator`


# ArgoCD Deployment on Amazon EKS

Instructions to deploy ArgoCD on an EKS cluster, fetch manifest files, and expose the ArgoCD dashboard using a Load Balancer.

#### Step 1: Create ArgoCD Namespace
ArgoCD operates in its own Kubernetes namespace. Run the following command to create the namespace:

```bash
kubectl create namespace argocd
```

#### Step 2: Apply ArgoCD Manifests
Next, apply the official ArgoCD manifests to install ArgoCD components in the `argocd` namespace:

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml
```

#### Step 3: Expose ArgoCD Server via LoadBalancer
By default, the ArgoCD server is not publicly accessible. To make it available, modify the service type to `LoadBalancer`:

1. Edit the ArgoCD server service:
   ```bash
   kubectl edit svc argocd-server -n argocd
   ```

2. Change the service type from `ClusterIP` to `LoadBalancer` and save the changes:
   ```yaml
   spec:
     type: LoadBalancer
   ```

#### Step 4: Retrieve Load Balancer Hostname
Once the service type is updated, get the external hostname or IP of the load balancer:

```bash
kubectl get svc argocd-server -n argocd -o json
```

Look for the `hostname` or `externalIP` field in the output. This will allow you to access the ArgoCD dashboard from a browser.

#### Step 5: Access the ArgoCD Dashboard
Using the Load Balancer's hostname, navigate to the ArgoCD dashboard via your browser:

```
http://<LOAD_BALANCER_HOSTNAME>
```

#### Step 6: ArgoCD Username and Password
The default username for the ArgoCD UI is `admin`. To retrieve the initial admin password, run the following command:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Use the following credentials to log in:

   - Username: `admin`
   - Password: `decoded value from above code`

---

With these steps, you have successfully deployed ArgoCD on EKS and exposed it via a Load Balancer. You can now manage your Kubernetes applications through ArgoCD’s UI.