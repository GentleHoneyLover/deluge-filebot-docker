# deluge-filebot-docker
Deluge Bittorrent client and filebot renaming tool in one container.

This container includes deluge 1.3 installed over an ubuntu 18.04 image. The reason for not running the latest deluge is because the filebot plugin doesn't support it yet.

## What's working so far:
- Supervisor config works
- Deluge daemon and Deluge web client succesfully run

## To-dos:
- Add the filebot command-line tool
- Sort out umasks, UIDs, etc.
- Check for any security conserns
