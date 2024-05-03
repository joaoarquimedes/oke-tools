#/usr/bin/env bash

# Define namespace name
NAMESPACE="<__NAMESPACE_NAME__>"

# List all types of resources in the specified namespace
for resource in $(kubectl api-resources --namespaced=true --verbs=list --output=name)
do
  echo "=== $resource ==="
  if ! kubectl get --namespace $NAMESPACE $resource 2>&1 | grep "No resources found" > /dev/null
  then
    # Create folder resource name
    [[ ! -d $resource ]] && mkdir $resource

    # Get all resource content
    function get_r_name(){
      kubectl get --namespace $NAMESPACE $resource -o custom-columns=NAME:.metadata.name
    }
    for i in $(get_r_name | grep -v "NAME")
    do
     echo "--> Save ${resource}/${i}.yml"
     kubectl get --namespace $NAMESPACE $resource ${i} -o yaml > ${resource}/${i}.yml
    done
  fi
done

