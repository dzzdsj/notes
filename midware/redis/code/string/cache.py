class Cache:
    def __init__(self, client):
        self.client = client

    def set(self, key, value):
        self.client.set(key, value)

    def get(self, key):
        return self.client.get(key)

    def delete(self, key):
        self.client.delete(key)

    def update(self, key, value):
        self.client.getset(key, value)
