# AMPTemplates-custom

Personal fork of the `call-of-dutymw2` AMP deployment template (originally by Greelan, later folded into [CubeCoders/AMPTemplates](https://github.com/CubeCoders/AMPTemplates)).

## Why this fork exists

The upstream template's "IW4x/AlterWare Launcher Download" step hardcodes a specific GitHub release tag + asset filename for [iw4x/launcher](https://github.com/iw4x/launcher). That project frequently prunes old prerelease builds and changes its asset naming convention between releases, so the hardcoded URL periodically starts returning 404 and breaks server updates/starts.

## Changes from upstream

- `call-of-dutymw2updates.json`: the launcher download step now resolves the *current* latest release from the GitHub API at update time instead of a pinned tag, for both Windows and Linux.
- `call-of-dutymw2updates.json`: added a "GunGame Mod Install" step that fetches `gungame-mod.zip` from this repo and extracts it into `mods/gungame`, so the mod is installed automatically instead of requiring manual setup.
- `call-of-dutymw2updates.json`: the winetricks download step now pulls `master` instead of a pinned release tag, for the same staleness reason.
- `call-of-dutymw2config.json`: `fs_game` now defaults to `mods/gungame`.
- `call-of-dutymw2server.cfg` / config file download step now points at this repo's copy instead of upstream's, so this fork is self-contained.

## Usage

Add `<owner>/AMPTemplates-custom:main` to ADS's Configuration Repositories list (`ADS.ConfigurationRepositories`) to make this template available in the Create Instance wizard, same as any other AMP template repo.
