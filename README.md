# Ansible Role: macOS Dock Automation

Role is used to automate use of [dockutil](https://github.com/kcrawford/dockutil) – command line tool for managing dock items. You can add, remove and re-arrange Dock items.

### Why to use this role?

* This version supports latest 3.x 'dockutil
* Items are added, positioned and removed in single command run instead of loops
* Latest MacOS Monterey support
* Can purge all items contained in Dock with one setting
* No need for ansible handlers and sudo rights to do killall and restart Dock, as it is handled by `dockutil` by itself!


## Requirements

  - **Homebrew**: Requires `homebrew` already installed (you can use `geerlingguy.mac.homebrew` to install it on your Mac).

## Role Variables

Available variables are listed below, along with example values (see `defaults/main.yml`):

```yaml
dockutil:
  remove_all: false
```

Removes all contents from dock, if set to false, then only items specified in `remove` will be removed.

```yaml
dockutil:
  remove: []
```

Dock items to remove.

```yaml
dockutil:
  add: []
```

Dock items to add. `pos` parameter is optional and will place the Dock item in a particular position in the Dock.


## Dependencies

  - (Soft dependency) `geerlingguy.homebrew`

## Example Playbook

```yaml
---
- hosts: localhost

  vars:
    dockutil:
      remove_all: false
      remove:
        - Launchpad
        - TV
        - Podcasts
        - 'App Store'
      add:
        - name: Messages
          path: "/Applications/Messages.app/"
        - name: Safari
          path: "/Applications/Safari.app/"
          position: 2
        - name: Sublime Text
          path: "/Applications/Sublime Text.app/"
          position: 3

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
