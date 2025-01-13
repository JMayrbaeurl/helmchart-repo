# Litmus Edge helm chart sample

This helm chart sample supports the deployment of [Litmus Edge](https://litmus.io/litmus-edge) to a Kubernetes cluster.

## Usage

### Prerequisites

The Litmus Edge container image is not available in a public repository. It's stored in private repository and therefore
needs some setup in the Kubernetes cluster first (see [Litmus Edge installation documentation](https://docs.litmus.io/litmusedge/quickstart-guide/installation-and-deployments/kubernetes-installation)).

Contact your Litmus account representative to get access to the service account .json file (typically called 'litmus-se-read-json'). Next create a corresponding
secret in the target Kubernetes namespace ('le-prod' used here as an example):

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
