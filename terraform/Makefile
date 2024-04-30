.PHONY tf_setup:
# use the tf_init, tf_format, tf_validate, tf_plan
tf_setup: tf_init tf_format tf_validate tf_plan

.PHONY tf_init:
tf_init:
	terraform init 

.PHONY tf_format:
tf_format:
	terraform fmt -recursive

.PHONY tf_validate:
tf_validate:
	terraform validate

.PHONY tf_plan:
tf_plan:
	terraform plan -var-file=terraform.tfvars 

.PHONY tf_apply:
tf_apply:
	terraform apply -auto-approve -var-file=terraform.tfvars 

## Speculative destroy (Wont destroy anything, just show what will be destroyed)
.PHONY tf_spec_destroy:
	terraform plan -destroy -var-file=terraform.tfvars 

.PHONY tf_destroy:
	terraform destroy -var-file=terraform.tfvars