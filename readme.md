# REST API Gateway with Restricted IP Access (Terraform)

This project provisions an **AWS REST API Gateway** that allows access **only from a specified IP address** (e.g., your home IP).  
It uses modular Terraform components to define the **Lambda functions** and **API routes**, enabling flexible and reusable infrastructure setup.

## Project Structure

```
app/
    get_hello_world.py
terraform-rest-api/
    modules/
        lambda/          
        api_gateway/     # Module to define API Gateway routes and integrations
    terraform files
    readme.md
```
## API Overview

The project currently exposes two sample endpoints under the `/dev` stage to test the Lambda and API modules:

| Path | Description |
|------|--------------|
| `/API_URL/dev/hello-world` | Simple Lambda returning a “Hello World” response |
| `/API_URL/dev/test` | Test endpoint for validating modular routing setup |

All endpoints are accessible **only from the configured IP** defined in your Terraform variables.

## IP Restriction

Access to the API Gateway is restricted using **resource policies** that allow requests only from your configured IP.

You can set or modify your IP in `vars.tf`. By default, a placeholder value is provided for faster setup.

To find your public IP go to [https://whatismyipaddress.com/](https://whatismyipaddress.com/)

## Considerations

### 1. Lambda Packaging
Terraform currently **zips the Lambda function locally** before deploying.  
This happens on every plan/apply, even if the Lambda code hasn’t changed.  
For larger Lambda packages, this can significantly slow down deployments
and rolling back becomes harder.

> **Recommendation:**  
> Move the zipping process to your CI/CD pipeline.  
> Refer to the existing example pipelines here:
> [serverless-MVP-app Pipelines](https://github.com/maurosorrentino/serverless-MVP-app/tree/main/.github/workflows)

### 2. API Accessibility
The API is still accessible via the **public internet**, though restricted by IP.

A fully private API setup would require:
- Placing API Gateway in a **VPC**
- Creating a **VPC endpoint**
- Accessing it via **VPN** or **AWS Direct Connect**
