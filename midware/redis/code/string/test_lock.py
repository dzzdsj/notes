from redis import Redis
from lock import Lock

client = Redis(
    host="192.168.50.99",
    port=6379,
    password="Redis_1991",
    decode_responses=True
)

lock = Lock(client, 'test_lock')
lock.acquire_lock()
lock.release_lock()
