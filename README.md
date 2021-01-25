## deluge-filebot-docker
Deluge Bittorrent client and filebot renaming tool in one container.

This container includes deluge 1.3 installed over an ubuntu 18.04 image. The reason for not running the latest deluge is because the filebot plugin doesn't support it yet.

# What's working so far:
- deluged and deluge-web succesfully run

# To-dos:
- The the filebot command-line tool
- sort out umasks, UIDs, etc.
- check for any security conserns
