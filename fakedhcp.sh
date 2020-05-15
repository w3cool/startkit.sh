
#!/bin/bash
IP=172.25.240       #定义变量

#检测网络链接畅通
function network()
{
    #超时时间
    local timeout=1
    #目标网站
    local target=www.baidu.com
    #获取响应状态码
    local ret_code=`curl -I -s --connect-timeout ${timeout} ${target} -w %{http_code} | tail -n1`
    if [ "x$ret_code" = "x200" ]; then
        #网络畅通
        return 1
    else
        #网络不畅通
        return 0
    fi
    return 0
}

network
if [ $? -eq 0 ];then
	echo "connection error，reconfigure ip address！"
    #扫描并设置ip
    for i in `seq 61 90`       #for循环，查找192.168.1.0-255的所有地址
    #for i in 192.168.1.{1,254}
    do
        ping -c 4 $IP.$i >  /dev/null 2>&1        #ping 4 times
        if [ `echo $?` -eq 0 ];then               #使用 echo$?判断命令执行结果的返回值
            echo -n "$IP.$i is online"
        else
            echo -n "$IP.$i is offline"
            nmcli connection modify ens192 ipv4.addresses "$IP.$i/24"
            nmcli connection reload
        fi
    done
	exit -1
fi

echo "connectivity is fine！"
exit 0





