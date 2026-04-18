testdkube := $(shell kubectl config current-context)
ifeq ($(testdkube), rancher-desktop)	
.PHONY: skaffold
skaffold: | postgres skaffold-infra

.PHONY: postgres
postgres:
	#helm search repo https://charts.bitnami.com/bitnami
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm upgrade --install postgres bitnami/postgresql --set primary.initdb.scripts."init\.sql"="  CREATE USER deps;  CREATE DATABASE deps;  ALTER USER deps with encrypted password 'deps';  GRANT ALL PRIVILEGES ON DATABASE deps TO deps;  CREATE USER preprocess;  CREATE DATABASE preprocess;  ALTER USER preprocess with encrypted password 'preprocess';  GRANT ALL PRIVILEGES ON DATABASE preprocess TO preprocess;  CREATE USER corleone;  CREATE DATABASE corleone;  ALTER USER corleone with encrypted password 'corleone';  GRANT ALL PRIVILEGES ON DATABASE corleone TO corleone;  CREATE USER file_storage;  CREATE DATABASE file_storage;  ALTER USER file_storage with encrypted password 'file_storage';  GRANT ALL PRIVILEGES ON DATABASE file_storage TO file_storage;  CREATE USER validation;  CREATE DATABASE validation;  ALTER USER validation with encrypted password 'validation';  GRANT ALL PRIVILEGES ON DATABASE validation TO validation;" \
		--version "11.0.2" \
		--timeout 300s \
        --atomic \
        --wait \
        --debug

.PHONY: skaffold-infra
skaffold-infra:
	cd skaffold && skaffold run -f skaffold.yaml 
endif

.PHONY: helm-deployment-rollback
helm-deployment-rollback:
	helm rollback --namespace $(NAMESPACE) $(CI_PROJECT_NAME) 0

.PHONY: helm-rollback
helm-rollback:
	make helm-deployment-rollback

.PHONY: run
run:
	docker compose up -d
