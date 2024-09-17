# Deployment Guide: Infrastructure Provisioning with Terraform and Minikube

This guide provides step-by-step instructions on how to deploy a complete infrastructure using Terraform and Minikube, covering three phases:

1. **Phase 1**: Setting up the network infrastructure.
2. **Phase 2**: Deploying applications on a Kubernetes cluster using Minikube.
3. **Phase 3**: Implementing observability with logging and monitoring tools.

Each phase includes instructions on initializing Terraform, planning the deployment, and applying the configuration.

---

## **Prerequisites**

Before you begin, ensure you have the following tools installed and configured:

- **Terraform** (v1.0 or later)
- **Minikube** (latest version)
- **kubectl** (compatible with your Minikube version)
- **Helm** (v3.0 or later)
- **Docker** (for running Minikube with the Docker driver)
- **Optional**: **LocalStack** (if you're using AWS services locally)

---

## **Phase 1: Setting Up Network Infrastructure**

### **Overview**

In this phase, you you will define network policies and namespaces to simulate a production environment.

### **Steps**

1. **Navigate to the Phase 1 Directory**

   ```bash
   cd phase-1
   ```

2. **Initialize Terraform**

   ```bash
   terraform init
   ```

3. **Validate the Terraform Configuration**

   ```bash
   terraform validate
   ```

4. **Review the Execution Plan**

   ```bash
   terraform plan
   ```

5. **Apply the Terraform Configuration**

   ```bash
   terraform apply
   ```

   - When prompted, type `yes` to confirm.

---

## **Phase 2: Deploying Applications on Minikube**

### **Overview**

In this phase, you'll:

- Deploy **minikube**.
- Deploy a demo API application with multiple replicas.
- Set up an ingress controller to expose the services within Minikube.

### **Steps**

1. **Navigate to the Phase 2 Directory**

   ```bash
   cd ../phase-2
   ```

2. **Start Minikube**

   If Minikube is not already running, start it:

   ```bash
   minikube start -p malaa --nodes 3
   ```

3. **Initialize Terraform**

   ```bash
   terraform init
   ```

4. **Validate the Terraform Configuration**

   ```bash
   terraform validate
   ```

5. **Review the Execution Plan**

   ```bash
   terraform plan
   ```

6. **Apply the Terraform Configuration**

   ```bash
   terraform apply
   ```

   - When prompted, type `yes` to confirm.

7. **Verify Kubernetes Cluster Access**

   ```bash
   kubectl get nodes
   ```

   - Ensure the node is in a `Ready` state.

---

## **Phase 3: Implementing Observability**

### **Overview**

In this phase, you'll:

- Deploy a logging and analytics solution (**Grafana Loki**).
- Deploy **Vector** to collect logs from all running applications.
- Configure log ingestion and visualization within Minikube.

### **Steps**

1. **Navigate to the Phase 3 Directory**

   ```bash
   cd ../phase-3
   ```

2. **Initialize Terraform**

   ```bash
   terraform init
   ```

3. **Validate the Terraform Configuration**

   ```bash
   terraform validate
   ```

4. **Review the Execution Plan**

   ```bash
   terraform plan
   ```

5. **Apply the Terraform Configuration**

   ```bash
   terraform apply
   ```

   - When prompted, type `yes` to confirm.

6. **Access Grafana Dashboard**

   - Since Minikube runs locally, you can use `kubectl port-forward` or `minikube service` to access the Grafana service.

   **Option 1: Using `minikube service`**

   ```bash
   minikube service loki-stack-grafana -n monitoring
   ```

   - This command will open the Grafana UI in your default web browser.

   **Option 2: Using `kubectl port-forward`**

   ```bash
   kubectl port-forward svc/loki-stack-grafana 3000:80 -n monitoring
   ```

   - Access Grafana at `http://localhost:3000`.

7. **Log in to Grafana**

   - Use username `admin` and the password specified in your Terraform configuration.

8. **Verify Log Ingestion**

   - In Grafana, add Loki as a data source.
   - Use the **Explore** feature to query logs and ensure that logs from your applications are being ingested.

### **Notes**

- Ensure that the `vector-config.yaml` file is correctly referenced in your `main.tf`.
- Confirm that the namespaces and service names match across your configurations.
- Monitor the pods in the `monitoring` namespace to ensure they are running properly.
- When using Minikube, services of type `LoadBalancer` can be accessed using `minikube tunnel` or by changing the service type to `NodePort`.

---

## **General Guidelines**

### **Terraform Commands**

- **Initialize Terraform**

  ```bash
  terraform init
  ```

  - Initializes the working directory containing Terraform configuration files.
  - Downloads necessary provider plugins.

- **Validate Configuration**

  ```bash
  terraform validate
  ```

  - Validates the syntax and internal consistency of the configuration files.

- **Review Execution Plan**

  ```bash
  terraform plan
  ```

  - Creates an execution plan, showing what actions Terraform will take.
  - Allows you to verify the changes before applying them.

- **Apply Configuration**

  ```bash
  terraform apply
  ```

  - Applies the changes required to reach the desired state of the configuration.
  - Prompts for confirmation before making changes.

- **Destroy Resources (Use with Caution)**

  ```bash
  terraform destroy
  ```

  - Destroys all resources managed by the Terraform configuration.
  - Useful for cleanup but should be used carefully to avoid unintended data loss.