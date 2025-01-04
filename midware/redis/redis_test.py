#pip install redis
from redis import Redis

# 配置连接信息
client = Redis(
    host='local_vm_centos',
    port=6379,
    password='your_password',
    db=0,
    socket_timeout=5,  # 连接超时时间为 5 秒
    decode_responses=True  # 自动解码响应
)

# 测试连接
if client.ping():
    print("Redis 服务器连接成功")
else:
    print("Redis 服务器连接失败")

