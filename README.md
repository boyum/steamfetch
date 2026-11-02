# steamfetch

Download Steam game files for a platform other than macOS. By default, `steamfetch` downloads the Windows depot for a Steam app, which is useful for running Windows-only games with Whisky, CrossOver, Parallels, or similar.

`steamfetch` is a small wrapper around [DepotDownloader](https://github.com/SteamRE/DepotDownloader). It does not bypass Steam ownership or DRM: you must own the game, and Steam may ask for Steam Guard approval.

## Requirements

- macOS
- [Homebrew](https://brew.sh/)
- A Steam account that owns the game
- A Windows runtime such as Whisky, CrossOver, or Parallels to run the downloaded game

## Install

```sh
git clone https://github.com/boyum/steamfetch.git
cd steamfetch
./install.sh
```

`install.sh` downloads the macOS DepotDownloader binaries, builds a Homebrew cask, installs it into a local tap, and links `steamfetch` into your `PATH`. Re-run the same command to update.

This installs:

- `steamfetch`
- `steamfetch-depotdownloader`

The installer uses a Homebrew cask with prebuilt binaries, so no compilation is required. It also removes the quarantine attribute from DepotDownloader so macOS can run it.

## Usage

```sh
steamfetch 3242710
steamfetch https://store.steampowered.com/app/3242710/Gambeat/
```

By default, files are downloaded into `./<Game Name>/`. To choose a base directory:

```sh
steamfetch 3242710 --dir ~/Games
```

To download directly into the chosen directory without a game-name subfolder:

```sh
steamfetch 3242710 --dir ~/Games/Gambeat --no-subfolder
```

Log in to Steam explicitly:

```sh
steamfetch 3242710 --username myuser --remember
steamfetch 3242710 --qr
```

Use `--anonymous` only for free apps:

```sh
steamfetch 480 --anonymous
```

Preview the command without downloading:

```sh
steamfetch 3242710 --dry-run
```

Show all options:

```sh
steamfetch --help
```

## Options

| Option | Description |
| --- | --- |
| `-d, --dir DIR` | Base output directory (default: current directory) |
| `--no-subfolder` | Download directly into `--dir` |
| `-u, --username USER` | Steam username |
| `--qr` | Log in by scanning a QR code |
| `--anonymous` | Anonymous login, for free apps only |
| `--remember` | Remember the Steam login token |
| `--validate` | Validate files that already exist |
| `-o, --os OS` | Target platform: `windows`, `macos`, or `linux` |
| `--arch ARCH` | Target architecture: `32` or `64` |
| `--all-archs` | Download all architecture-specific depots |
| `--language LANG` | Language to download |
| `--all-languages` | Download all language depots |
| `--manifest-only` | Download manifests only |
| `--dry-run` | Print the command without downloading |
| `-- <args>` | Pass extra arguments to DepotDownloader |

## How it works

`steamfetch` resolves the app ID and game name, then runs DepotDownloader with `-os windows -osarch 64` by default. The downloaded files are the same depot files Steam would serve to a Windows client.

Some apps, especially unreleased or "coming soon" games, may not have downloadable depots yet. In that case DepotDownloader will report that no depots are available.

## Uninstall

```sh
brew uninstall --cask steamfetch
```

## Development

```sh
./build.sh    # rebuild dist zips and update cask checksums
./install.sh  # build and reinstall the local cask
```

The first build downloads DepotDownloader 3.4.0 into `.cache/`. Build artifacts in `dist/` are not committed.
