# ruby_url_shortener

**Ruby URL Shortener** is a simple and fast Telegram bot that lets you shorten long URLs into compact, easy-to-share links right within Telegram.

## Features

- Shorten any valid URL right in Telegram.
- View and manage your shortened links via interactive menu buttons like **"My Links"** and **"Shorten URL"**.
- Delete any of your previously shortened links.
- Navigate through intuitive inline buttons.
- Handles both messages and callback queries smoothly.
- Commands supported: `/start`
- Uses a PostgreSQL database with Sequel ORM to persist user and link data.

## Technologies Used

- Ruby + Sequel ORM
- PostgreSQL (via Docker)
- Telegram Bot API with `telegram-bot-ruby` gem
- Sinatra (for URL redirector)  
- Minitest for testing

## To-Do

☐ **Link Statistics:** Show how many times each shortened link was used.  
☐ **Link Expiration & Limits:** Implement expiration dates and usage limits for shortened links.  
☐ **Custom Aliases:** Let users set custom short aliases for their URLs.  
☐ **Error Handling:** Improve user feedback for invalid URLs or other errors.  
☐ **More Commands:** Add `/help`, cancel commands, and additional UX commands.  
☐ **Rate Limiting / Spam Protection:**  Prevent overload and spam.

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
7. The bot will run inside the Docker container and connect to the configured database.
8. Interact with your Telegram bot by sending messages and commands in Telegram.
