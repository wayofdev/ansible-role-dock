<br>

<div align="center">
<img width="456" src="https://raw.githubusercontent.com/wayofdev/ansible-role-dock/master/assets/logo.gh-light-mode-only.png#gh-light-mode-only">
<img width="456" src="https://raw.githubusercontent.com/wayofdev/ansible-role-dock/master/assets/logo.gh-dark-mode-only.png#gh-dark-mode-only">
</div>

<br>

<br>

<div align="center">
<a href="https://actions-badge.atrox.dev/wayofdev/ansible-role-dock/goto"><img alt="Build Status" src="https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fwayofdev%2Fansible-role-dock%2Fbadge&style=flat-square"/></a>
<a href="https://galaxy.ansible.com/wayofdev/dock"><img alt="Ansible Role" src="https://img.shields.io/ansible/role/59499?style=flat-square"/></a>
<a href="https://github.com/wayofdev/ansible-role-dock/tags"><img src="https://img.shields.io/github/v/tag/wayofdev/ansible-role-dock?sort=semver&style=flat-square" alt="Latest Version"></a>
<a href="https://galaxy.ansible.com/wayofdev/dock"><img alt="Ansible Quality Score" src="https://img.shields.io/ansible/quality/59499?style=flat-square"/></a>
<a href="https://galaxy.ansible.com/wayofdev/dock"><img alt="Ansible Role" src="https://img.shields.io/ansible/role/d/59499?style=flat-square"/></a>
<a href="LICENSE"><img src="https://img.shields.io/github/license/wayofdev/ansible-role-dock.svg?style=flat-square&color=blue" alt="Software License"/></a>
<a href="#"><img alt="Commits since latest release" src="https://img.shields.io/github/commits-since/wayofdev/ansible-role-dock/latest?style=flat-square"></a>
</div>

<br>

# Ansible Role: macOS Dock Automation

Role is used to automate use of [dockutil](https://github.com/kcrawford/dockutil) – command line tool for managing Dock items. You can add, remove and re-arrange Dock items.

If you **like/use** this role, please consider **starring** it. Thanks!

<br>

## 🗂 Table of contents

* [Benefits of this role](#-benefits-of-this-role)
* [Requirements](#-requirements)
* [Role Variables](#-role-variables)
  * [Structure](#-structure)
  * [Adding](#-adding)
  * [Adding with Replace](#-adding-with-replace)
  * [Adding folders](#-adding-folders)
  * [Removing](#-removing)
  * [Moving](#-moving)
* [Example Playbook](#-example-playbook)
* [Development](#-development)
* [Testing](#-testing)
  * [on localhost](#-on-localhost)
  * [over SSH](#-over-ssh)
* [Dependencies](#-dependencies)
* [Compatibility](#-compatibility)
* [License](#-license)
* [Author Information](#-author-information)
* [Credits and Resources](#-credits-and-resources)
* [Contributors](#-contributors)

<br>

## ⭐️ Benefits of this role:

* This version supports latest 3.x [dockutil](https://github.com/kcrawford/dockutil)
* Items are added, positioned and removed in single command run instead of loops
* Latest macOS Monterey support
* Can erase all items contained in Dock with one setting
* No need for ansible handlers and sudo rights to do `killall` to restart Dock, as it is handled by `dockutil` by itself!
* Supports all `dockutil` options, like:
`--add, --remove, --move, --replacing, --position, --after, --before, --section, --allhomes, --sort, --display, --view`

<br>

## 📑 Requirements

  - **Homebrew**: Requires `homebrew` already installed (you can use `wayofdev.homebrew` to install it on your macOS).
  - Up-to-date version of ansible. During maintenance/development, we stick to ansible versions and will use new features if they are available (and update `meta/main.yml` for the minimum version).
- Compatible OS. See [compatibility](#-compatibility) table.
- Role has dependencies on third-party roles on different operating systems. See `requirements.yml` and [dependencies](#-dependencies) section.

<br>

## 🔧 Role Variables

Section shows all possible variants of adding, moving, replacing and removing of applications, spacers, folders. Available variables are listed below, along with example values (see `defaults/main.yml`):

<br>

### → Structure

Group controls installation of dockutil, and allows to select custom tap:

```yaml
# Should we try to install dockutil?
dock_dockutil_install: <true | false> # (default: true) Install dockutil using homebrew.

# Path to custom or official tap of dockutil
dock_dockutil_tap: lotyp/formulae/dockutil # By default, 3.x tap is used
```

Role allows to wipe macOS dock completely:

```yaml
# Removes all contents from dock including "others" section with Downloads folder.
# Prefer this option on new installations together with configured "dockitems".
dock_dockitems_erase_all: <true | false> # Whether to attempt to erase all items in Dock including Downloads folder! (default: false)
```

Variable structure to add, move, or remove items in Dock:

```yaml
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

**Adds** `Time Machine.app` in the middle of Dock:

```yaml
dock_dockitems:
  - label: Time Machine
    action: add
    path: /System/Applications/Time Machine.app
    position: middle
```

**Adds** `TextEdit.app` after the item `Time Machine.app` in every user's Dock on that machine:

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

**Replaces** `Time Machine.app` with `Mail.app` in the current user's Dock

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

## 📗 Example Playbook

```yaml
---
- hosts: all

	# is needed when running over SSH
  environment:
    - PATH: "/usr/local/bin:/usr/local/sbin:/opt/homebrew/bin:{{ ansible_env.PATH }}"

  vars:
    dock_dockitems_erase_all: true
    dock_dockitems:
      - label: Messages
        action: add
        path: /System/Applications/Messages.app

      - label: Safari
        action: add
        path: /Applications/Safari.app

      - label: Sublime Text
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

**Install** [poetry](https://github.com/python-poetry/poetry) using [poetry-bin](https://github.com/gi0baro/poetry-bin) and all dev python dependencies:

```bash
$ make install
```

**Install** only python dependencies, assuming that you already have poetry:

```bash
$ make install-deps
```

**Install** all git hooks:

```bash
$ make hooks
```

**Lint** all role files:

```bash
$ make lint
```

<br>

## 🧪 Testing

You can check `Makefile` to get full list of commands for remote and local testing. For local testing you can use these comands to test whole role or separate tasks:

### → on localhost

> :warning: **Notice**: By defaut all tests are ran against your local machine!

```bash
# run all tags with scenario from ./tests/test.yml
$ make test

# or test-tag without any parameters
$ make test-tag

# run idempotency check
$ make test-idempotent

# run tasks that validate config file and does installation
$ export TASK_TAGS="dock-validate dock-install"
$ make test-tag

# run by predefined command that executes only one tag
$ make test-validate
$ make test-install
$ make test-manipulate
$ make test-add
$ make test-remove
$ make test-move

# run molecule tests on localhost
$ poetry run molecule test --scenario-name defaults-restored-on-localhost -- -vvv

# or with make command
$ make m-local
```

<br>

### → over SSH

```bash
# run molecule scenarios against remote machines over SSH
# this will need VM setup and configuration
$ poetry run molecule test --scenario-name defaults-restored-over-ssh -- -vvv

$ make m-remote

# tags also can be passed
$ export TASK_TAGS="dock-validate dock-install"
$ make m-remote
```

<br>

## 📦 Dependencies

Installation handled by `Makefile` and requirements are defined in `requirements.yml`

  - [wayofdev.homebrew](https://github.com/wayofdev/ansible-role-homebrew) - soft dependency, required if Homebrew isn't installed yet
  - [ansible.community.general](https://docs.ansible.com/ansible/latest/collections/community/general/index.html)

<br>

## 🧩 Compatibility

This role has been tested on these systems:

| system / container | tag      |
| :----------------- | -------- |
| macos              | monterey |
| macos              | big-sur  |

<br>

## 🤝 License

[![Licence](https://img.shields.io/github/license/wayofdev/ansible-role-dock?style=for-the-badge&color=blue)](./LICENSE)

<br>

## 🙆🏼‍♂️ Author Information

This role was created in **2022** by [lotyp / wayofdev](https://github.com/wayofdev).

<br>

## 🧱 Credits and Resources

**Inspired by:**

* original role created by [@geerlingguy](https://github.com/geerlingguy) as a part of [ansible-collection-mac](https://github.com/geerlingguy/ansible-collection-mac).
* [dockutil](https://github.com/kcrawford/dockutil)

<br>

## 🫡 Contributors

<img align="left" src="https://img.shields.io/github/contributors-anon/wayofdev/ansible-role-dock?style=for-the-badge"/>

<a href="https://github.com/wayofdev/ansible-role-dock/graphs/contributors">
  <img src="https://opencollective.com/wod/contributors.svg?width=890&button=false">
</a>
