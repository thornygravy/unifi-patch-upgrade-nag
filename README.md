# UniFi Patch Upgrade Nag

Removes the insanely annoying "Upgrade to UniFi OS Server" nag pop-up modal from the UniFi Network Application.

## Instructions

1. Mount the script at `/custom-cont-init.d/patch-upgrade-nag.sh`.
2. Make the script executable:

   ```bash
   chmod +x patch-upgrade-nag.sh
   ```

### Docker

```bash
-v ./patch-upgrade-nag.sh:/custom-cont-init.d/patch-upgrade-nag.sh
```

### Compose

```yaml
volumes:
  - ./patch-upgrade-nag.sh:/custom-cont-init.d/patch-upgrade-nag.sh
```

## Notes

Tested working on 10.6.106.

## License

MIT License. See [LICENSE](LICENSE) for details.
