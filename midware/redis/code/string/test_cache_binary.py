from redis import Redis
from cache import Cache
client = Redis(
    host="192.168.50.99",
    port=6379,
    password="Redis_1991"
)
cache = Cache(client)
image = open("test.jpg", "rb")
data = image.read()
image.close()
cache.set("test.jpg", data)
cache.get("test.jpg")
