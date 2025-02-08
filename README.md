> **Disclaimer:** _This is not a community framework or distribution._ It's a
> private configuration and an ongoing experiment to feel out NixOS. I make no
> guarantees that it will work out of the box for anyone but myself. It may also
> change drastically and without warning.

Shamelessly copied from [jboyens](https://git.sr.ht/~jboyens/dotfiles) who shamelessly copied from [hlissner](https://github.com/hlissner/dotfiles)

------

|                |                                                          |
|----------------|----------------------------------------------------------|
| **Shell:**     | zsh + zgenom                                             |
| **DM:**        | greetd                                                   |
| **WM:**        | Sway                                                     |
| **Editor:**    | [Doom Emacs][doom-emacs]                                 |
| **Terminal:**  | foot                                                     |
| **Launcher:**  | rofi                                                     |
| **Browser:**   | firefox                                                  |

------

# Setup
## Partitions
### EFI partition
Label: `boot`
Mountpoint: `/boot`
Size: `512M`

### Primary Partition
Label: `nixos`
Mountpoint: `/`, `/nix/store`
Size: `*`

```
# Format primary partition as a luks-encrypted partition
cryptsetup luksformat /dev/nvme0n1p2

# Open/map primary parititon to /dev/mapper/cryptroot
cryptsetup luksOpen /dev/nvme0n1p2

# Format and label decrypted partition
mkfs.ext4 -L nixos /dev/mapper/cryptroot

# Mountin' time
mkdir /mnt
mount /dev/disk/by-label/nixos /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
```

Get the UUID of the encrypted partition (`nvme0n1p2` in the following output):
`lsblk -f`
```
NAME          FSTYPE      FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
nvme0n1                                                                                   
├─nvme0n1p1   vfat        FAT32 boot  ABA3-0D61                             422.7M    17% /boot
└─nvme0n1p2   crypto_LUKS 2           8ea5b5eb-3dc9-4406-a061-f1d5dcb7950f                
  └─cryptroot ext4        1.0   nixos 1e26657b-742c-4a8c-a681-def6a132be9f    1.7T     2% /nix/store
                                                                                          /
```

Modify the `/hosts/.../disk-configuration.nix` line:
```
boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/8ea5b5eb-3dc9-4406-a061-f1d5dcb7950f";
```

## Nix-index db generation
`nix run github:nix-community/nix-index#nix-index`

