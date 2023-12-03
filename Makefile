IMP_SA=sa-developer@data-engineering-406915.iam.gserviceaccount.com
PROJECT_ID=data-engineering-406915

gcp-auth:
	gcloud config set project ${PROJECT_ID}
	gcloud config set auth/impersonate_service_account ${IMP_SA}

gcp-unset:
	gcloud config unset project
	gcloud config unset auth/impersonate_service_account