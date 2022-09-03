# media.nvim

A [neovim](https://neovim.io/) plugin that displays media files instead of its
binary content.

**Note:** This plugin is still in development and is not ready for use.

## Requirements

- neovim 0.7+
- [ueberzug](https://github.com/seebye/ueberzug) for displaying media.
- [ffmpegthumbnailer](https://github.com/dirkvdb/ffmpegthumbnailer) (optional)
  for video preview support
- [pdftoppm](https://linux.die.net/man/1/pdftoppm) (optional) for pdf preview
  support. Available in the AUR as **poppler** package.
- [epub-thumbnailer](https://github.com/marianosimone/epub-thumbnailer)
  (optional) for epub preview support.
- [fontpreview](https://github.com/sdushantha/fontpreview) (optional), for font
  preview support

Notice that you can use your own script to display any media instead of the
built-in script for ueberzug. See [configuration](#configuration).

## Installation

Use your favorite plugin manager. For example, using
[packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use({
  'NFrid/media.nvim',
  config = function()
    require('media-nvim').setup()
  end,
})
```

### Configuration

In the setup function, you can pass a table to overwrite any options. Here are
the defaults:

```lua
require('media-nvim').setup({
  -- these are the only supported by the script
  filetypes = { 'png', 'jpg', 'gif', 'mp4', 'webm', 'pdf' },
  -- path to the script that will be used to display the media on the terminal
  -- usage must be: script_path {file} {x} {y} {width} {height}
  script_path = '*PLUGIN_INSTALLATION_PATH*/media.nvim/scripts/render',
})
```

## Big thanks

- [telescope-media-files.nvim](https://github.com/nvim-telescope/telescope-media-files.nvim)
  for the script.
