python3 k8s/VboxK8S.py execute --template charts/templates/deployment/1.rolling-update-deployment.yaml --location inner --action replace

git clone -b develop git@git.youle.game:TC/TSD/PDG/gmtools.git

from k8s.tools.deployment import Deployment
import yaml

d = Deployment()
f = open('charts/templates/deployment/rolling_update.yaml')
body = yaml.load(f)

d.replace('nginx', 'rolling-update', body)