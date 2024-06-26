Creds go to `/etc/vanta.conf`

Contents should look like:
```
{
  "AGENT_KEY": "",
  "OWNER_EMAIL": "",
  "NEEDS_OWNER": true
}
```

Last but no least, fix the file permissions if they aren't correct:

```
sudo chown root:root /etc/vanta.conf
sudo chmod 600 /etc/vanta.conf
```
