# Crypto Trading Platform - Backend API

## Overview
A comprehensive Rails 7 API backend for a cryptocurrency trading platform with features including user authentication, KYC verification, wallet management, cryptocurrency trading, and payment processing.

## Features

### User Management
- User registration and authentication with JWT tokens
- Password reset and change functionality
- Profile management

### KYC (Know Your Customer)
- Document upload (Aadhaar, PAN, Selfie)
- Admin approval/rejection workflow
- KYC status tracking

### Wallet Management
- Multi-currency wallet support (INR + Crypto)
- Wallet balance tracking
- Transaction history (ledger)

### Trading
- Buy/Sell cryptocurrency orders
- Order preview and execution
- Trade history tracking
- Real-time price updates

### Payments
- Razorpay payment gateway integration
- Deposit management
- Withdrawal management with blockchain support

### Admin Panel
- Dashboard with key metrics
- KYC approval/rejection
- Currency and trading pair management

## Tech Stack

- **Framework**: Rails 7
- **Database**: PostgreSQL
- **Cache**: Redis
- **Background Jobs**: Sidekiq
- **Authentication**: JWT
- **API**: RESTful
- **Payment**: Razorpay

## Installation

### Prerequisites
- Ruby 3.2.0
- PostgreSQL 15+
- Redis 7+
- Node.js 18+

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/msantosh34/crypto-trading-platform.git
   cd crypto-trading-platform/backend
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup environment variables**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` with your configuration.

4. **Create and migrate database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

5. **Start the server**
   ```bash
   rails s
   ```

6. **Start Sidekiq (in another terminal)**
   ```bash
   bundle exec sidekiq
   ```

## Docker Setup

If you prefer using Docker:

```bash
docker-compose up -d
docker-compose exec web rails db:create db:migrate db:seed
```

## API Documentation

### Authentication

#### Register
```
POST /api/v1/auth/register
Body: { email, password, password_confirmation }
```

#### Login
```
POST /api/v1/auth/login
Body: { email, password }
Response: { token, user }
```

#### Logout
```
POST /api/v1/auth/logout
Headers: { Authorization: Bearer <token> }
```

### Wallets

#### Get All Wallets
```
GET /api/v1/wallets
Headers: { Authorization: Bearer <token> }
```

#### Get Wallet by Currency
```
GET /api/v1/wallets/:currency_code
Headers: { Authorization: Bearer <token> }
```

#### Get Wallet History
```
GET /api/v1/wallets/:currency_code/history?limit=50&offset=0
Headers: { Authorization: Bearer <token> }
```

### Trading

#### Buy Preview
```
POST /api/v1/trades/buy/preview
Body: { trading_pair_id, quantity_or_amount, order_type }
Headers: { Authorization: Bearer <token> }
```

#### Execute Buy
```
POST /api/v1/trades/buy/execute
Body: { order_id }
Headers: { Authorization: Bearer <token> }
```

#### Sell Preview
```
POST /api/v1/trades/sell/preview
Body: { trading_pair_id, quantity_or_amount, order_type }
Headers: { Authorization: Bearer <token> }
```

#### Execute Sell
```
POST /api/v1/trades/sell/execute
Body: { order_id }
Headers: { Authorization: Bearer <token> }
```

#### Trade History
```
GET /api/v1/trades/history?limit=50&offset=0
Headers: { Authorization: Bearer <token> }
```

### Deposits

#### Initiate Deposit
```
POST /api/v1/deposits/initiate
Body: { amount }
Headers: { Authorization: Bearer <token> }
```

#### Confirm Deposit
```
POST /api/v1/deposits/confirm
Body: { deposit_id, razorpay_payment_id, razorpay_signature }
Headers: { Authorization: Bearer <token> }
```

### Withdrawals

#### Create Withdrawal
```
POST /api/v1/withdrawals
Body: { currency_code, amount, wallet_address }
Headers: { Authorization: Bearer <token> }
```

### Prices

#### Get Current Price
```
GET /api/v1/prices/current?currency_code=BTC
```

#### Get All Prices
```
GET /api/v1/prices/all
```

#### Get Price History
```
GET /api/v1/prices/history?currency_code=BTC&hours=24
```

### Admin

#### Dashboard
```
GET /api/v1/admin/dashboard
Headers: { Authorization: Bearer <admin_token> }
```

#### Pending KYC
```
GET /api/v1/admin/kyc/pending
Headers: { Authorization: Bearer <admin_token> }
```

#### Approve KYC
```
PUT /api/v1/admin/kyc/:id/approve
Headers: { Authorization: Bearer <admin_token> }
```

#### Reject KYC
```
PUT /api/v1/admin/kyc/:id/reject
Body: { reason }
Headers: { Authorization: Bearer <admin_token> }
```

## Project Structure

```
backend/
├── app/
│   ├── controllers/
│   │   └── api/v1/
│   ├── models/
│   ├── services/
│   ├── serializers/
│   ├── mailers/
│   ├── jobs/
│   └── views/
├── config/
│   ├── initializers/
│   ├── routes.rb
│   └── database.yml
├── db/
│   ├── migrate/
│   ├── seeds.rb
│   └── schema.rb
├── lib/
│   └── tasks/
├── spec/
├── Gemfile
├── Dockerfile
├── docker-compose.yml
└── .env.example
```

## Testing

```bash
rspec
```

## Contributing

Contributions are welcome! Please create a pull request with your changes.

## License

MIT License
