# Bounty Bulletin Board Mod

A Project Zomboid mod that adds a placeable bulletin board for posting and claiming bounties. Players can post item or cash rewards on any board in the world, view active bounties, and remove completed or unwanted posts. All data is persisted across saves and synchronized in multiplayer sessions.

## Features

- Extend the built-in Cork Noteboard to support bounty postings
- Post and view bounties via context menu interactions
- Per-board bounty storage using `worldObject:getModData()`
- Remove, persist, and synchronize bounties across saves and servers
- Compatible with Project Zomboid b42 and later

## Installation

1. Copy the `bountybulletin` folder into your `Zomboid/mods/` directory.
2. Enable **Bounty Bulletin Board** in the Mods menu.
3. Start or load a game, then right-click a corkboard to post or view bounties.

## Contributing

Contributions are welcome! Please follow this workflow:

1. Fork the repository on GitHub.
2. Create a branch for your feature or fix:
   - `feature/awesome-feature`
   - `bugfix/123-fix-typo`
3. Commit your changes and push your branch:
   ```bash
   git add .
   git commit -m "Add awesome feature"
   git push origin feature/awesome-feature
   ```
4. Open a Pull Request against the `master` branch and describe your changes.
5. Wait for review and merge.

## Reporting Issues

If you encounter any bugs or have feature requests, please open an issue on GitHub:

1. Search existing issues to avoid duplicates.
2. Click **New Issue** and fill out the template with:
   - Reproduction steps
   - Expected vs. actual behavior
   - Logs or screenshots (if applicable)

## License

This project is licensed under the [MIT License](LICENSE).
