


```bash
$# helm repo add my-repo https://charts.bitnami.com/bitnami
$# helm install my-release my-repo/rabbitmq --set global.storageClass="standard" --set replicaCount=3
NAME: my-release
LAST DEPLOYED: Fri Oct  7 16:15:15 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: rabbitmq
CHART VERSION: 10.3.9
APP VERSION: 3.10.8** Please be patient while the chart is being deployed **

Credentials:
    echo "Username      : user"
    echo "Password      : $(kubectl get secret --namespace default my-release-rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 -d)"
    echo "ErLang Cookie : $(kubectl get secret --namespace default my-release-rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 -d)"

Note that the credentials are saved in persistent volume claims and will not be changed upon upgrade or reinstallation unless the persistent volume claim has been deleted. If this is not the first installation of this chart, the credentials may not be valid.
This is applicable when no passwords are set and therefore the random password is autogenerated. In case of using a fixed password, you should specify it when upgrading.
More information about the credentials may be found at https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues/#credential-errors-while-upgrading-chart-releases.

RabbitMQ can be accessed within the cluster on port 5672 at my-release-rabbitmq.default.svc.cluster.local

To access for outside the cluster, perform the following steps:

To Access the RabbitMQ AMQP port:

    echo "URL : amqp://127.0.0.1:5672/"
    kubectl port-forward --namespace default svc/my-release-rabbitmq 5672:5672

To Access the RabbitMQ Management interface:

    echo "URL : http://127.0.0.1:15672/"
    kubectl port-forward --namespace default svc/my-release-rabbitmq 15672:15672
```