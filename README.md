# Example Terraform Project - Kubernetes Namespace

This repository contains a basic example of how to use Terraform with the `hashicorp/kubernetes` provider. The purpose of this project is to serve as an educational exercise, introducing the basic concepts of Terraform modules, providers, and configuration. **This example is not intended for production use.**

## Project Structure

The project structure is as follows:
root  
├── main.tf  
├── modules  
│   └── namespace  
│       ├── main.tf  
│       ├── outputs.tf  
│       └── variables.tf  
├── outputs.tf  
├── .terraform.lock.hcl  
├── terraform.tfstate  
├── terraform.tfvars  
└── variables.tf  


### Files and Directories:

- **`main.tf`**: The root configuration file where the main setup of the project is defined.
- **`modules/namespace/`**: Contains the reusable module named `namespace` which is used to create a Kubernetes namespace.
  - **`main.tf`**: Defines the resources within the `namespace` module.
  - **`outputs.tf`**: Outputs variables for the `namespace` module.
  - **`variables.tf`**: Specifies the input variables required by the `namespace` module.
- **`outputs.tf`**: Defines output values for the root module, such as `ns_id`.
- **`.terraform.lock.hcl`**: Lock file generated by Terraform to ensure consistent provider versions.
- **`terraform.tfstate`**: The state file that tracks the current status of the infrastructure managed by Terraform.
- **`terraform.tfvars`**: Contains the variable values that are passed to the root module configuration.
- **`variables.tf`**: Defines the input variables for the root module.

## Example Workflow

This example project demonstrates how to:

1. Create a reusable Terraform module.
2. Use the `hashicorp/kubernetes` provider to create a namespace in a Kubernetes cluster.
3. Pass input variables to the module from the root configuration.
4. Output values after applying the configuration.

### Prerequisites

- Terraform installed on your local machine.
- Access to a Kubernetes cluster.
- Properly configured Kubernetes provider credentials.

#### Setup Rancher Desktop as Kubernetes environment

To have a local Kubernetes environment to test out this project with, go to the [Rancher Installation page](https://docs.rancherdesktop.io/getting-started/installation#linux).  
**Make sure to follow the instructions**

To install GPG and Pass you can issue the following command:
```bash
sudo apt install gpg pass
```

To make sure Traefik can handle the ports for this worksop example, it is important you issue the command 
```bash
sudo sysctl -w net.ipv4.ip_unprivileged_port_start=80
```

Once Rancher Desktop is installed, start it and wait for it to warm up. Rancher will automatically create a kubeconfig for you in `~/.kube/config`, and no authorization is necessary.

### How to Run

1. Clone this repository:
   ```bash
   git clone https://github.com/aiqueneldar/terraform-example.git
   cd terraform-example
   ```
   
   Take note that there is a terraform.tfstate included in the projekt. It is safe to delete this file before starting experimentation, and it is incurraged to do so.

2. Initialize the Terraform configuration:
   ```bash
   terraform init
   ```

3. Check the plan to see the changes that will be applied:
   ```bash
   terraform plan
   ```

4. Apply the configuration to create the namespace:
   ```bash
   terraform apply
   ```
   Once the process completes, the namespace ID (ns_id) will be outputted as a result.

5. To destroy the resources:
   ```bash
   terraform destroy
   ```

## Disclaimer

**This project is for educational purposes only.** It is intended to demonstrate basic Terraform functionality and should not be used in a production environment. Always review and customize any Terraform code before deploying to your infrastructure.

## Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs/)
- [Kubernetes Provider Documentation](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)

