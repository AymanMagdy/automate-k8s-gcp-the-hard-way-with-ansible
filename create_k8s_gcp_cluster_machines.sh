#! /bin/bash

# The public IP
PUBLIC_IP=$(gcloud compute addresses describe kubernetes-controller \
--region $(gcloud config get-value compute/region) \
--format 'value(address)')

# Creating the master machine.
gcloud compute instances create controller \
--async \
--boot-disk-size 200GB --can-ip-forward \
--image-family ubuntu-1804-lts \
--image-project ubuntu-os-cloud \
--machine-type n1-standard-1 \
--private-network-ip 10.240.0.10 \
--scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
--subnet kubernetes \
--address $PUBLIC_IP

# Creating the 2 worker machines in the cluster.
for i in 0 1; do \
    gcloud compute instances create worker-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family ubuntu-1804-lts \
    --image-project ubuntu-os-cloud \
    --machine-type n1-standard-1 \
    --private-network-ip 10.240.0.2${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet kubernetes;
done