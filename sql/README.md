## Setup Instructions

Follow these steps to set up your development environment and run the SQL exercises.

### 1. Install Python

- Make sure Python 3.10 or higher is installed.  
- Check installation:

```bash
python --version
```

- If not installed, download Python from https://www.python.org/downloads/ and follow the instructions for your OS.

### 2. Set up a Virtual Environment
1. Create a virtual environment in your project folder:

```bash
python -m venv .venv
```

2. Activate the virtual environment:

```bash
.venv\Scripts\activate.bat
```

### 3. Install Required Packages
- Make sure you are in the virtual environment.
- Install dependencies from `requirements.txt`:

```bash
pip install -r requirements.txt
```

### Set Up VS Code (Optional but Recommended)
1. Install [Visual Studio Code](https://code.visualstudio.com/)
2. Open the project folder in VS Code.
3. Recommended extensions:
    - Python
    - Jupyter
    - Prettier

```mermaid
---
title: MMO Database
---
erDiagram
    "CLASS" {
        int id PK
        string name
        string description
    }

    RACE {
        int id PK
        string name
        string description
    }

    PLAYER {
        int id PK
        string username
        int gold
        int class_id FK
        int race_id FK
    }

   LEVEL {
      int id PK
      int experience_required
   }

   PLAYER_LEVEL {
      int player_id PK,FK
      int current_level FK
      int current_experience
   }

    GUILD {
        int id PK
        string name
        string description
    }

    PLAYER_GUILD {
        int player_id FK
        int guild_id FK
        date joined_date
    }

    GUILD_ROLE {
        int id PK
        string name
        string description
    }

    PLAYER_GUILD_ROLE {
        int player_id FK
        int guild_id FK
        int role_id FK
    }

    STAT {
        int id PK
        string name
        string acronym
    }

    PLAYER_STAT {
        int player_id FK
        int stat_id FK
        int value
    }

    "CLASS" ||--o{ PLAYER : "chosen class"
    RACE ||--o{ PLAYER : "chosen race"

   PLAYER ||--|| PLAYER_LEVEL : "has level"
   LEVEL ||--o{ PLAYER_LEVEL : "defines requirements"

    PLAYER ||--o{ PLAYER_GUILD : "is member"
    GUILD ||--o{ PLAYER_GUILD : "has members"

    PLAYER_GUILD ||--|| PLAYER_GUILD_ROLE : "assigns role to member"
    GUILD_ROLE ||--o{ PLAYER_GUILD_ROLE : "available roles"

    PLAYER ||--o{ PLAYER_STAT : "has stat"
    STAT ||--o{ PLAYER_STAT : "defines"
```