@okurkaiedova's dotfiles
========================

Setup
-----

* Install GNU [stow]:

  * on macOS:

    ```bash
    $ brew install stow
    ```

  * on Ubuntu

    ```bash
    $ [sudo] apt install stow
    ```

  * on Arch Linux

    ```bash
    $ [sudo] pacman -S stow
    ```

* Clone the repo and switch to its root:

  ```bash
  $ git clone https://github.com/olha-kurkaiedova/dotfiles.git
  $ cd dotfiles
  ```

* Run `stow` for a bundle you want to use:

  ```bash
  $ stow -t ~ %bundle%
  ```

  where 

  * `%bundle%` - a bundle to isntall (e.g. `bash`)


Dependencies
------------

* `bash`

  Depends on [vcstatus] project in order to show VCS hints in your prompt. Can
  be installed via `cargo`:

  ```bash
  $ cargo install vcstatus
  ```


[stow]: https://www.gnu.org/software/stow/
[vcstatus]: https://github.com/ikalnytskyi/vcstatus
