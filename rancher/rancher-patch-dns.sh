#!/bin/sh
kubectl -n cattle-system patch  daemonsets cattle-node-agent --patch '{
    "spec": {
        "template": {
            "spec": {
                "hostAliases": [
                    {
                        "hostnames":
                        [
                            "your domain"
                        ],
                            "ip": "your ip"
                    }
                ]
            }
        }
    }
}'