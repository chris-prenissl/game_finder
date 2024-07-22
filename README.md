# Game Finder

## Overview

_Game Finder_ is a flutter application for iOS and Android that lets you search the IGDB library
and mark your favorites.

## Technologies

_Flutter_ | _Dart_ | _bloc_ | _http_ | _hive_ | _go_router_

## Images

![Game Finder Screen 1](screenshots/search.png) ![Casual Chess Screen 2](screenshots/game.png)

## Usage

### Prerequisites

- Flutter SDK
- Installed iOS or Android Emulator

### Installation

1. Use your twitch account to create a new app project (see: https://api-docs.igdb.com/#getting-started)
2. Clone this repository:
   ```bash
   git clone https://github.com/chris-prenissl/game_finder.git
   ```
3. Create a .env file in the project's root with the following secrets from IGDB
   ```bash
   CLIENT_ID=client_id
   CLIENT_SECRET=client_secret
   ```
4. Start a emulator

5. Open the Terminal inside the project folder:
   ```bash
   flutter run
   ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.