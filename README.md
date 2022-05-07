# 

<div align="center">
<img width="456" height="60" src="./assets/logo.gh-light-mode-only.png#gh-light-mode-only">
<img width="456" height="60" src="./assets/logo.gh-dark-mode-only.png#gh-dark-mode-only">
</div>

<br>

<div align="center">
<a href="https://actions-badge.atrox.dev/wayofdev/ansible-role-dock/goto"><img alt="Build Status" src="https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fwayofdev%2Fansible-role-dock%2Fbadge&style=flat-square"/></a>
<a href="https://github.com/wayofdev/ansible-role-dock/releases"><img src="https://img.shields.io/github/release/wayofdev/ansible-role-dock.svg?style=flat-square" alt="Latest Version"></a>
<a href="https://galaxy.ansible.com/lotyp/dock">
<img alt="Ansible Quality Score" src="https://img.shields.io/ansible/quality/59069?style=flat-square"/></a>
<a href="https://galaxy.ansible.com/lotyp/dock">
<img alt="Ansible Role" src="https://img.shields.io/ansible/role/d/59069?style=flat-square"/></a>
<a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square" alt="Software License"/></a>
</div>

<br>

# Ansible Role: macOS Dock Automation

Role is used to automate use of [dockutil](https://github.com/kcrawford/dockutil) – command line tool for managing dock items. You can add, remove and re-arrange Dock items.

#### Benefits of this role:

* This version supports latest 3.x [dockutil](https://github.com/kcrawford/dockutil)
* Items are added, positioned and removed in single command run instead of loops
* Latest MacOS Monterey support
* Can erase all items contained in Dock with one setting
* No need for ansible handlers and sudo rights to do `killall` to restart Dock, as it is handled by `dockutil` by itself!
* Supports all `dockutil` options, like:
`--add, --remove, --move, --replacing, --position, --after, --before, --section, --allhomes, --sort, --display, --view`



## Requirements

  - **Homebrew**: Requires `homebrew` already installed (you can use `geerlingguy.mac.homebrew` to install it on your Mac).
  - **ansible.community.general** – installation handled by `Makefile`



## Role Variables

Available variables are listed below, along with example values (see `defaults/main.yml`):

```yaml
dockutil:
  erase_all: false
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
      erase_all: true

      dockitems:
        - name: Messages
          action: add
          path: /System/Applications/Messages.app/

        - name: Messages
          action: add
          path: /Applications/Safari.app/

        - name: Sublime Text
          action: add
          path: "/Applications/Sublime Text.app/"
          position: 3

  roles:
    - geerlingguy.mac.homebrew
    - lotyp.dock
```



## License

[![Licence](https://img.shields.io/github/license/wayofdev/ansible-role-dock?style=for-the-badge)](./LICENSE)



## Author Information

This role was created in **2022** by [lotyp / wayofdev](https://github.com/wayofdev).

Inspired by original role created by [@geerlingguy](https://github.com/geerlingguy) as a part of [ansible-collection-mac](https://github.com/geerlingguy/ansible-collection-mac).
