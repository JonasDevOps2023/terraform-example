# Exercises to try out

## Exercise 1
1. Go to [Kubernetes provider - Deployment page](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment#example-usage)
   Copy the example code and paste it into your main.tf file in the root module

2. Run the different terraform commands to see that everything looks good
   ```bash
   terraform fmt
   terraform validate
   terraform plan
   ```

3. If everything seems fine then apply the changes
   ```bash
   terraform apply
   ```

   This might take a while for Kubernetes to provision, there might be messages from Terraform saying it is still running

4. If everything was successfull you should be able to see a new deployment in Rancher Cluster Dashboard -> under Workloads -> Deployments

5. Now change the namespace where this Deployment exsists to the "web" namespace we created in the first run
   
   In your main.tf file, find the first `metadata` keyword, should be first under the resource  
   add a new line under `name = "terraform-example"`:  
   ```terraform
   namespace = "web"
   ```

   still in main.tf find the next `metadata` section under the `template` keyword  
   add a new line here ass well above the `labels` line:
   ```terraform
   namespace = "web"
   ```

6. Run a new plan to see what terraform wants to change (you can also run `terraform fmt` and `terraform validate` to make sure everything looks good)

   ```bash
   terraform plan
   ```

7. Terraform should tell you that the resource can't be changed in place, and have to be replaced. This means removing the old one and creating a new one. Go ahead and do that this time

   ```bash
   terraform apply
   ```

8. Once Terraform have made the changes you should still have the deployment but it should now be in the `web` namespace instead of the `default` namespace

## Excercise 2

1. Change the namespace lines in your main.tf kubernetes deployment resource to use a variable instead.

   Just like before we could use `var.ns_name`, but let's be more creative (to get to try things out)

2. When we create a namespace with the `namespace' module, it has an output we could use instead

   change both lines in the deployment part of your main.tf file to instead use this output:
   ```terraform
   namespace = module.namespace.namespace_id
   ```

3. Run `terraform plan` if you did this correctly, there should be no changes

4. Edit the file `terraform.tfvars`  and change the value of the variable `ns_name` to something else than `web`

5. Run `terraform plan` again, there should now be several changes

6. Run `terraform apply` and the changes should be applied

## Exercise 3

To be able to see the Nginx default page in a browser we need to add to more things, a Service and an Ingress. Follow the steps below to do so.

1. Copy the following resource into your main.tf file

   ```terraform   
   resource "kubernetes_service" "example-service" {
     metadata {
       name = "example-service"
       labels = {
         app = "example-app"
       }
   		namespace = module.namespace.namespace_id
     }
     spec {
       type = "ClusterIP"
       selector = {
         test = "MyExampleApp"
       }
       port {
         port        = 80
         target_port = 80
         protocol    = "TCP"
       }
     }
   }
   ```

2. Then copy the following resource into your main.tf file

   ```terraform
   resource "kubernetes_ingress_v1" "example-ingress" {
     metadata {
       name = "example-ingress"
   		namespace = module.namespace.namespace_id
   		annotations = {
   			"traefik.ingress.kubernetes.io/router.entrypoints" = "web"
   		}
     }
   	
     spec {
       ingress_class_name = "traefik"
       rule {
   			host = "example.127.0.0.1.sslip.io"
         http {
           path {
             path = "/"
   					path_type = "Prefix"
             backend {
               service {
                 name = kubernetes_service.example-service.metadata.0.name
                 port {
                   number = 80
                 }
               }
             }
           }
         }
       }
     }
   }
   ```

3. Run `terraform apply`, this should give you a lot of changes that Terraform wants to apply. Apply all the changes

4. If everything worked you should now be able to access your Nginx in a webbrowser on the address;
   ```bash
   example.127.0.0.1.sslip.io
   ```

