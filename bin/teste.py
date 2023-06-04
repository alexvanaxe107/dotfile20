import os

user = os.environ['HOME']

CONFIG_PATH = "%s/%s" % (user, ".config/wallfinder")

print(CONFIG_PATH)
