TF_STATE_BUCKET =
TF_STATE_KEY =
TF_STATE_REGION =
TF_VARS_FILE ?= "../config/terraform.tfvars"
DEPLOY_REGION ?= ${TF_STATE_REGION}

TF_VARS = -var 'region=$(DEPLOY_REGION)' \
	-var-file="$(TF_VARS_FILE)"

TF_BACKEND_CONFIG := -backend-config="bucket=$(TF_STATE_BUCKET)" \
	-backend-config="key=$(TF_STATE_KEY)" \
	-backend-config="region=$(TF_STATE_REGION)"

COMPOSE_RUN_TERRAFORM = docker-compose run --rm --workdir="/opt/app/deploy" tf

.PHONY: run_plan
run_plan: init plan

.PHONY: run_apply
run_apply: init apply

.PHONY: run_destroy_plan
run_destroy_plan: init destroy_plan

.PHONY: run_destroy_apply
run_destroy_apply: init destroy_apply

.PHONY: run_test_deploy
run_test_deploy: init

.PHONY: init
init:
	$(COMPOSE_RUN_TERRAFORM) init -input=false $(TF_BACKEND_CONFIG)
	-$(COMPOSE_RUN_TERRAFORM) validate
	-$(COMPOSE_RUN_TERRAFORM) fmt

.PHONY: plan
plan:
	$(COMPOSE_RUN_TERRAFORM) plan -out=tfplan -input=false $(TF_VARS)

.PHONY: apply
apply:
	$(COMPOSE_RUN_TERRAFORM) apply "tfplan"

.PHONY: destroy_plan
destroy_plan:
	$(COMPOSE_RUN_TERRAFORM) plan -destroy $(TF_VARS)

.PHONY: destroy_apply
destroy_apply:
	$(COMPOSE_RUN_TERRAFORM) destroy -auto-approve
