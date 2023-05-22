To use this Terraform code:

    Set up your AWS credentials and ensure that the AWS CLI is configured with the appropriate access and secret key.

    Create a new directory and place the above code in a file named main.tf.

    Modify the code to match your desired configuration. Specifically, replace the region, subnet IDs, security group IDs, and S3 bucket ARN with your own values.

    Open a terminal or command prompt, navigate to the directory where the Terraform code is saved.

    Initialize the Terraform working directory by running the following command:
        terraform init

Deploy the EKS cluster by executing the following command:
    
    terraform apply

After the deployment is complete, you can interact with the EKS cluster using the AWS CLI or Kubernetes tools like kubectl.

To run a pod on the new EKS cluster with an IAM role assigned to access an S3 bucket:

    Ensure that you have the kubectl command-line tool installed and configured to communicate with the EKS cluster.

Create a Kubernetes service account and associate it with the IAM role by creating another manifest file (e.g., service-account.yaml) with the following content:

    apiVersion: v1
    kind: ServiceAccount
    metadata:
        name: my-service-account
    annotations:
        eks.amazonaws.com/role-arn: arn:aws:iam::YOUR_ACCOUNT_ID:role/eks-cluster-role # Replace with your AWS account ID and role name

Create a Kubernetes manifest file (e.g., pod.yaml) with the following content:

        apiVersion: v1
        kind: Pod
        metadata:
            name: my-pod
        spec:
            containers:
            - name: my-container
                image: nginx
            automountServiceAccountToken: true
            serviceAccountName: my-service-account


Apply the Kubernetes manifests to create the pod and service account by running the following commands:

    kubectl apply -f service-account.yaml
    kubectl apply -f pod.yaml

Remember to clean up resources when you no longer need them by running terraform destroy. This will remove the EKS cluster, IAM roles, policies, and any associated resources created by Terraform.