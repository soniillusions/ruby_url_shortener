# ruby_url_shortener

**Ruby URL Shortener** is a simple and fast Telegram bot that lets you shorten long URLs into compact, easy-to-share links right within Telegram.

## Features

- Shorten any valid URL.
- View a list of your shortened links (`/my_links` command).
- Delete shortened links from your list.
- Interactive menus with inline buttons for navigation and creating new links.
- Handles different message types and callback queries.
- Commands supported: `/start`, "Shorten URL", "My Links", etc.
- Stores user and link data in a PostgreSQL database using Sequel ORM.

## Technologies Used

- Ruby + Sequel ORM
- PostgreSQL (via Docker)
- Telegram Bot API with `telegram-bot-ruby` gem
- Sinatra (for URL redirector)  
- Minitest for testing

## To-Do

☐ **Link Statistics:** Show how many times each shortened link was used.  
☐ **Export Links:** Allow exporting links to CSV or JSON.  
☐ **Custom Aliases:** Let users set custom short aliases for their URLs.  
☐ **Error Handling:** Improve user feedback for invalid URLs or other errors.  
☐ **More Commands:** Add `/help`, cancel commands, and additional UX commands.

## Setup & Usage

1. Clone the repository.
2. Create a .env file in the project root and add your Telegram bot token, database credentials, and other required environment variables.
   ```
    TELEGRAM_BOT_TOKEN=your_telegram_bot_token_here
    DATABASE_URL=postgres://user:password@db_host:5432/database_name
    BASE_URL=https://your.domain.com
   ```
4. Build and start the Docker containers:
   ```
    docker-compose build
    docker-compose up -d
   ```
5. (Optional) Configure Nginx as a reverse proxy if needed, and start/reload Nginx.
   ```
   server {
        listen 80;
        server_name your.domain.com;
    
        location / {
            proxy_pass http://localhost:3000; # или порт вашего приложения
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
   ```
6. Reload Nginx to apply changes:
   ```
   sudo nginx -s reload
   ```
7. The bot will run inside the Docker container and connect to the configured database.
8. Interact with your Telegram bot by sending messages and commands in Telegram.
