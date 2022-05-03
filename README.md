# Ansible Role: macOS Dock Automation

Role is used to automate use of [dockutil](https://github.com/kcrawford/dockutil) – command line tool for managing dock items. You can add, remove and re-arrange Dock items.

## Requirements

  - **Homebrew**: Requires `homebrew` already installed (you can use `geerlingguy.mac.homebrew` to install it on your Mac).

## Role Variables

Available variables are listed below, along with example values (see `defaults/main.yml`):

```yaml
dockutil:
  remove: []
```

Dock items to remove.

```yaml
dockutil:
  persist: []
```

Dock items to add. `pos` parameter is optional and will place the Dock item in a particular position in the Dock.

## Dependencies

  - (Soft dependency) `geerlingguy.homebrew`

## Example Playbook

```yaml
    - hosts: localhost

      vars:
        dockutil:
          remove:
            - Launchpad
            - TV
            - Podcasts
            - 'App Store'
          persist:
            - name: Messages
              path: "/Applications/Messages.app/"
            - name: Safari
              path: "/Applications/Safari.app/"
              pos: 2
            - name: Sublime Text
              path: "/Applications/Sublime Text.app/"
              pos: 3

      roles:
        - geerlingguy.mac.homebrew
        - lotyp.dock
```

See the [Mac Provisioner Playbook](https://github.com/wayofdev/playbook-mac-provisioner) for an example of this role's usage.

## License

MIT

## Author Information

This role was created in 2022 by [lotyp / wayofdev](https://github.com/wayofdev).

The original role created by [@geerlingguy](https://github.com/geerlingguy) as a part of [ansible-collection-mac](https://github.com/geerlingguy/ansible-collection-mac).
