from redis import Redis

# client = Redis(
#     host="local_vm_redhat",
#     username="default",
#     password="Redis_1991"
# )
client = Redis(
    host="192.168.50.99",
    port=6379,
    password="Redis_1991"
)

if client.ping() is True:
    print("connecting")
else:
    print("disconnected")