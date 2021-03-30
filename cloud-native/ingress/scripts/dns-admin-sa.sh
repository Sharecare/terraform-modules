#!/bin/bash

# Note you need to have enough permissions to run this script. 
# use the terraform-sa@terraform-254700.iam.gserviceaccount.com 
# service account if you have access


function usage(){
  filename=`basename -- $0`
  echo -e "\nNo arguments supplied\n"
  echo -e "usage:"
  echo -e "${filename} PROJECT_ID \n"
}

if [ $# -ne 1 ]
then
    usage
else
    PROJECT_ID=$1

    # cert_service_account=`gcloud iam service-accounts --project ${PROJECT_ID} list | grep certmgr-cdns-admin | wc -l`
    # if [ $cert_service_account -eq  "0" ] 
    # then 
    tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
    # run the following if you are running this script independently from the install.sh script.
    # gcloud beta container clusters get-credentials ${CLUSTER} --region ${REGION} --project ${PROJECT_ID}

    CLOUD_DNS_SA=certmgr-cdns-admin-$(date +%s)
    gcloud iam service-accounts --project ${PROJECT_ID} create ${CLOUD_DNS_SA} \
        --display-name=${CLOUD_DNS_SA} \
        --project=${PROJECT_ID}

    gcloud iam service-accounts keys create ${tmp_dir}/gcp-dns-admin.json \
        --iam-account=${CLOUD_DNS_SA}@${PROJECT_ID}.iam.gserviceaccount.com \
        --project=${PROJECT_ID}

    gcloud projects add-iam-policy-binding ${PROJECT_ID} \
        --member=serviceAccount:${CLOUD_DNS_SA}@${PROJECT_ID}.iam.gserviceaccount.com \
        --role=roles/dns.admin

    kubectl create secret generic cert-manager-credentials \
        --from-file=${tmp_dir}/gcp-dns-admin.json --namespace ingress

    rm -f ${tmp_dir}/gcp-dns-admin.json
    # else 
    #     echo "service account exists"
    # fi 

fi 