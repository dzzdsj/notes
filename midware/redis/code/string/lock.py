VALUE_OF_LOCK = "locking"


class Lock:
    def __init__(self, redis_client, key):
        self.redis_client = redis_client
        self.key = key


    def acquire_lock(self):
        result = self.redis_client.set(self.key, VALUE_OF_LOCK, nx=True)
        return result is True


    def release_lock(self):
        return self.redis_client.delete(self.key) == 1
