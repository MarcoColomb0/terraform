# Terraform Configurations 🚀

This repository contains Terraform configurations that I use to test and learn Terraform, an infrastructure as code software tool. The configurations are for various cloud platforms, including:

* Amazon Web Services (AWS) ☁️
* Microsoft Azure & Azure Active Directory (now Entra ID) 🌐

The configurations are organized into directories based on the cloud platform.

## Getting Started 

To use the configurations in this repository, you will need to have Terraform installed. You can download Terraform from the Terraform website: [https://www.terraform.io/](https://www.terraform.io/).

Once you have Terraform installed, you can clone this repository to your local machine:

```
git clone https://github.com/MarcoColomb0/terraform.git
```

Then, you can change to the directory for the cloud platform that you want to use and run the `terraform init` command to initialize the configuration:

```
cd aws
terraform init
```

This will download the necessary modules and providers for the AWS configuration.

Once the configuration has been initialized, you can run the `terraform plan` command to see a preview of the changes that Terraform will make:

```
terraform plan
```

Finally, you can run the `terraform apply` command to apply the changes:

```
terraform apply
```

This will create the infrastructure resources that are defined in the configuration.

## Contributing 🤝

If you would like to contribute to this repository, please fork the repository and create a pull request. The pull request should include a README file that provides more information about the configuration. 

Let me know if you'd like any other adjustments or additions! 
