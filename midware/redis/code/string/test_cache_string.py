from redis import Redis
from cache import Cache

client = Redis(
    host="192.168.50.99",
    port=6379,
    password="Redis_1991",
    decode_responses=True
)
cache = Cache(client)
print(cache.get("name"))
cache.set("name", "John")
print(cache.get("name"))
cache.update("name", "Jane")
print(cache.get("name"))
cache.delete("name")
