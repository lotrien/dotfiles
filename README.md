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
  $ git clone https://github.com/lotrien/dotfiles.git
  $ cd dotfiles
  ```

* Run `stow` for a bundle you want to use:

  ```bash
  $ stow -t ~ %bundle%
  ```

  where

  * `%bundle%` - a bundle to isntall (e.g. `bash`)


[stow]: https://www.gnu.org/software/stow/
