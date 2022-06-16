<br>

<div align="center">
<img width="456" height="60" src="./assets/logo.gh-light-mode-only.png#gh-light-mode-only">
<img width="456" height="60" src="./assets/logo.gh-dark-mode-only.png#gh-dark-mode-only">
</div>
<br>

<br>

<div align="center">
<a href="https://actions-badge.atrox.dev/wayofdev/ansible-role-dock/goto"><img alt="Build Status" src="https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fwayofdev%2Fansible-role-dock%2Fbadge&style=flat-square"/></a>
<a href="https://galaxy.ansible.com/lotyp/ansible-role-dock"><img alt="Ansible Role" src="https://img.shields.io/ansible/role/59069?style=flat-square"/></a>
<a href="https://github.com/wayofdev/ansible-role-dock/tags"><img src="https://img.shields.io/github/v/tag/wayofdev/ansible-role-dock?sort=semver&style=flat-square" alt="Latest Version"></a>
<a href="https://galaxy.ansible.com/lotyp/dock">
<img alt="Ansible Quality Score" src="https://img.shields.io/ansible/quality/59069?style=flat-square"/></a>
<a href="https://galaxy.ansible.com/lotyp/dock">
<img alt="Ansible Role" src="https://img.shields.io/ansible/role/d/59069?style=flat-square"/></a>
<a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square" alt="Software License"/></a>
</div>

<br>

# Ansible Role: MacOS Dock Automation

Role is used to automate use of [dockutil](https://github.com/kcrawford/dockutil) – command line tool for managing Dock items. You can add, remove and re-arrange Dock items.

If you **like/use** this role, please consider **starring** it. Thanks!

<br>

### → Benefits of this role:

* This version supports latest 3.x [dockutil](https://github.com/kcrawford/dockutil)
* Items are added, positioned and removed in single command run instead of loops
* Latest MacOS Monterey support
* Can erase all items contained in Dock with one setting
* No need for ansible handlers and sudo rights to do `killall` to restart Dock, as it is handled by `dockutil` by itself!
* Supports all `dockutil` options, like:
`--add, --remove, --move, --replacing, --position, --after, --before, --section, --allhomes, --sort, --display, --view`

<br>

## 📑 Requirements

  - **Homebrew**: Requires `homebrew` already installed (you can use `wayofdev.homebrew` to install it on your macOS).

<br>

## 🔧 Role Variables

Section shows all possible variants of adding, moving, replacing and removing of applications, spacers, folders. Available variables are listed below, along with example values (see `defaults/main.yml`):

<br>

### → Structure

Structure of dictionary item for **adding** apps. All available options are listend below:

```yaml
# Should we try to install dockutil?
dock_dockutil_install: <true | false> # (default: true) Install dockutil using homebrew.

# Path to custom or official tap of dockutil
dock_dockutil_tap: lotyp/formulae/dockutil # By default 3.x tap is used

# Removes all contents from dock including "others" section with Downloads folder.
# Prefer this option on new installations together with configured "dockitems".
dock_dockitems_erase_all: <true | false> # Whether to attempt to erase all items in Dock including Downloads folder! (default: false)

dock_dockitems:
  - label: <label> # Used in search for existing items or names new apps"
    action: <add | remove | move>
    path: <label | app bundle id | path | url> # Example: /System/Applications/TextEdit.app
    replacing: <label | app bundle id | path | url> # Label or app bundle id of item to replace. Replaces the item with the given dock label or adds the item to the end if item to replace is not found"
    position: <[+/-]index_number | beginning | end | middle> # Inserts the item at a fixed position: can be position by index number or keyword"
    after: <label | application bundle id> # Inserts the item immediately after the given dock label or at the end if the item is not found
    before: <label | application bundle id> # Inserts the item immediately before the given dock label or at the end if the item is not found
    section: <apps | others> # Specifies whether the item should be added to the apps or others section
    display: <folder | stack> # Folder display option when adding a folder
    sort: <name | dateadded | datemodified | datecreated | kind> # Folder sort option when adding a folder
    type: <spacer | small-spacer | flex-spacer> # Specify a custom tile type for adding spacers
    allhomes: <true | false> # Whether to attempt to locate all home directories and perform the operation on each of them (default: false)
```

<br>

### → Adding

**Adds** `TextEdit.app` to the end of the current user's Dock:

```yaml
dock_dockitems:
  - label: TextEdit
    action: add
    path: /System/Applications/TextEdit.app
```

**Adds** `Time Machine` in the middle of Dock:

```yaml
dock_dockitems:
  - label: Time Machine
    action: add
    path: /System/Applications/Time Machine.app
    position: middle
```

**Adds** TextEdit.app after the item `Time Machine` in every user's Dock on that machine:

```yaml
dock_dockitems:
  - label: TextEdit
    action: add
    path: /System/Applications/TextEdit.app
    after: Time Machine
    allhomes: true # optional parameter
```

<br>

### → Adding with Replace

**Replaces** `Time Machine` with `Mail.app` in the current user's Dock

```yaml
dock_dockitems:
  - label: Mail
    action: add
    path: /System/Applications/Mail.app
    replacing: Time Machine
```

<br>

### → Adding folders

**Adds** `Downloads` folder to `others` section of Dock menu. On click will open preview in grid mode.

```yaml
dock_dockitems:
  - label: Downloads
    action: add
    path: ~/Downloads
    view: grid
    display: folder
    allhomes: true # optional parameter
```

<br>

### → Removing

**Removes** `TextEdit` in every user's Dock on that machine:

```yaml
dock_dockitems:
  - label: TextEdit
    action: remove
    allhomes: true # optional parameter
```

**Removes** all spacer tiles:

```yaml
dock_dockitems:
  - label: spacer-tiles
    action: remove
```

<br>

### → Moving

**Moves** `System Preferences` to the second slot on every user's dock on that machine:

```yaml
dock_dockitems:
  - label: System Preferences
    action: move
    position: end # <[+/-]index_number | beginning | end | middle>
    allhomes: true # optional parameter
```

<br>

## 📦 Dependencies

  - (Soft dependency) `wayofdev.homebrew`

<br>

## 📗 Example Playbook

```yaml
---
- hosts: localhost

  vars:
		dock_dockutil_install: true
		dock_dockitems_erase_all: true
    dock_dockitems:
      - name: Messages
        action: add
        path: /System/Applications/Messages.app

      - name: Messages
        action: add
        path: /Applications/Safari.app

      - name: Sublime Text
        action: add
        path: /Applications/Sublime Text.app
        position: 3

  roles:
    - wayofdev.homebrew
    - wayofdev.dock
```

<br>

## ⚙️ Development

To install dependencies and start development you can check contents of our `Makefile`

**Install** depdendencies:

```bash
$ make install-deps
```

**Install** all git hooks:

```bash
$ make hooks
```

<br>

## 🧪 Testing

For local testing you can use these comands to test whole role or separate tasks:

> :warning: **Notice**: By defaut all tests are ran against your local machine!

```bash
# run all tasks: validation, install, analytics, add, move, remove
$ make test

# run idempotency check
$ make test-idempotent

# or test-tag without any parameters
$ make test-tag

# run tasks that validates config file
$ export TASK_TAGS="dock-validate"; make test-tag

# run tasks that tries to install dockutil
$ export TASK_TAGS="dock-install"; make test-tag

# run all tags
$ export TASK_TAGS="dock-validate dock-install dock-manipulate dock-add dock-remove dock-move"; make test-tag
```

Full list of commands can be seen in `Makefile`.

<br>

## 🧩 Compatibility

This role has been tested on these systems:

| system / container | tag      |
| :----------------- | -------- |
| macos              | monterey |
| macos              | big-sur  |

<br>

## 🤝 License

[![Licence](https://img.shields.io/github/license/wayofdev/ansible-role-dock?style=for-the-badge)](./LICENSE)

<br>

## 🙆🏼‍♂️ Author Information

This role was created in **2022** by [lotyp / wayofdev](https://github.com/wayofdev).

Inspired by original role created by [@geerlingguy](https://github.com/geerlingguy) as a part of [ansible-collection-mac](https://github.com/geerlingguy/ansible-collection-mac).
