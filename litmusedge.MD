# Litmus Edge helm chart sample

This helm chart sample supports the deployment of [Litmus Edge](https://litmus.io/litmus-edge) to a Kubernetes cluster.

## Usage

### Prerequisites

The Litmus Edge container image is not available in a public repository. It's stored in private repository and therefore
needs some setup in the Kubernetes cluster first (see [Litmus Edge installation documentation](https://docs.litmus.io/litmusedge/quickstart-guide/installation-and-deployments/kubernetes-installation)).

Contact your Litmus account representative to get access to the service account .json file (typically called 'litmus-se-read-json'). Next create a corresponding
secret in the target Kubernetes namespace ('le-prod' used here as an example):

### Deployment

First create a namespace (recommended) and create the secret for the docker configuration of the Litmus private container image repository.

```Powershell
kubectl create namespace 'le-prod'
$serviceAccountPassword = Get-Content ./litmus-se-read.json
kubectl create secret docker-registry litmus-credential --docker-server=us-docker.pkg.dev --docker-username=_json_key --docker-password=serviceAccountPassword
```

Add this helm repo if you've not done yet by ('jmayrbaeurl' is used as sample here, choose what ever you want)

```Powershell
helm repo add jmayrbaeurl https://raw.githubusercontent.com/jmayrbaeurl/helmchart-repo/master/index
helm repo update jmayrbaeurl
```

Then run the helm chart and install with default values:

```Powershell
helm upgrade --install litmusedge jmayrbaeurl/litmusedge -n le-prod --create-namespace 
```

Attention: The helm chart creates a persistent volume claim for the default storage class, that's used to store all data.
This persistent volume claim won't be deleted by deleting the Helm release.

### Remarks

As already mentioned, Litmus.io only provides a container image with the 'latest' tag in their private container image
repository. That's quite inconvenient, because any restart of the container could trigger an unwanted update.
Therefore it's highly recommended to use an own private container image registry, e.g. Azure Container registry, and tag
the Litmus Edge image manually. And of course override the helm chart with the corresponding values.

### Deployment of Litmus Edge solutions

Currently only the Microsoft Manufacturing data solutions ([MDS](https://learn.microsoft.com/en-us/industry/manufacturing/manufacturing-data-solutions/overview-manufacturing-data-solutions)) Litmus Edge solution is supported. It can be deployed
together with Litmus Edge by running:

```Powershell
helm upgrade --install litmusedge jmayrbaeurl/litmusedge -n le-prod --create-namespace --set litmusEdgeSolutions.mds.enabled=true -f "<Your path>\override.yaml"
```

The 'override.yaml file' contains the configuration for the connector. See the [Litmus.io documentation](https://docs.litmus.io/solutions/litmus-edge-guide-for-azure-manufacturing-data-solutions-mds) for details

```yaml
litmusEdgeSolutions:
  mds:
    env:
      - name: EDGE_IP_ADDRESS
        value: "litmusedge-docker.le-prod.svc.cluster.local"
      - name: EDGE_API_TOKEN
        value: "<insert your api token>"
      - name: EDGE_NATS_TOKEN
        value: "<insert your nats token>"
      - name: MDS_PUBLISHER_ID_SUFFIX
        value: "<optional - recommended to set wih a value>"
      - name: BATCH_SIZE
        value: "100"
```
