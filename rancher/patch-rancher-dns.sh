kubectl -n cattle-system patch  daemonsets cattle-node-agent --patch '{
    "spec": {
        "template": {
            "spec": {
                "hostAliases": [
                    {
                        "hostnames":
                        [
                            "admin.cloud.p2.hbtv.com.cn"
                        ],
                            "ip": "172.25.242.169"
                    }
                ]
            }
        }
    }
}'