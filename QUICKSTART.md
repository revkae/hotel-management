# Quick Start Guide

## Step 1: Install Dependencies

```bash
npm install
```

## Step 2: Start RabbitMQ

### Using Docker (Recommended):
```bash
docker run -d --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3-management
```

Access RabbitMQ Management UI at http://localhost:15672 (username: guest, password: guest)

### Alternative - Windows:
Download and install from https://www.rabbitmq.com/download.html

## Step 3: Setup Database

The database is already configured. To reset or regenerate:

```bash
npx prisma generate
npx prisma db push
```

## Step 4: Start the Application

```bash
npm run start:dev
```

You should see:
```
Application is running on: http://localhost:3000/api
```

## Step 5: Test the API

### Option A: Using Postman
1. Import `Postman_Collection.json` into Postman
2. Run requests from the collection

### Option B: Using cURL

#### Create a User:
```bash
curl -X POST http://localhost:3000/api/users -H "Content-Type: application/json" -d "{\"name\":\"John Doe\",\"email\":\"john@example.com\",\"number\":\"+1234567890\"}"
```

#### Create a Hotel:
```bash
curl -X POST http://localhost:3000/api/hotels -H "Content-Type: application/json" -d "{\"hotelName\":\"Grand Plaza\",\"location\":\"New York\"}"
```

#### Create a Reservation:
```bash
curl -X POST http://localhost:3000/api/reservations -H "Content-Type: application/json" -d "{\"customerName\":\"John Doe\",\"phone\":\"+1234567890\",\"location\":\"New York\",\"mail\":\"john@example.com\",\"date\":\"2025-12-15T14:00:00Z\",\"userId\":1,\"hotelId\":1}"
```

#### Get All Reservations:
```bash
curl http://localhost:3000/api/reservations
```

## Step 6: Monitor RabbitMQ Events

Watch the application console. When you create/update/delete a reservation, you'll see messages like:
```
Reservation created event received: { id: 1, customerName: 'John Doe', ... }
```

## Common Commands

```bash
# Start development server
npm run start:dev

# Build for production
npm run build

# Run production build
npm run start:prod

# Generate Prisma Client
npx prisma generate

# Reset database
npx prisma db push --force-reset

# View database in Prisma Studio
npx prisma studio
```

## Testing Checklist for Presentation

- [ ] RabbitMQ is running
- [ ] Application starts without errors
- [ ] Can create a user (POST /api/users)
- [ ] Can create a hotel (POST /api/hotels)
- [ ] Can create a reservation (POST /api/reservations)
- [ ] RabbitMQ events appear in console
- [ ] Can retrieve reservations (GET /api/reservations)
- [ ] Postman collection works

## For Demo Video

1. Show the architectural diagram from ARCHITECTURE.md
2. Start RabbitMQ in one terminal
3. Start the app in another terminal (npm run start:dev)
4. Open Postman and show the collection
5. Execute: Create User → Create Hotel → Create Reservation
6. Switch to terminal to show RabbitMQ event logs
7. Execute GET request to show the created reservation with related data

## Troubleshooting

### Application won't start
- Check if port 3000 is available
- Ensure dependencies are installed (npm install)

### RabbitMQ connection error
- Verify RabbitMQ is running on localhost:5672
- Check Docker container status: `docker ps`
- Restart RabbitMQ: `docker restart rabbitmq`

### Prisma errors
- Regenerate client: `npx prisma generate`
- Reset database: `npx prisma db push --force-reset`

### "Cannot find module" errors
- Delete node_modules and reinstall: `rm -rf node_modules && npm install`
- Regenerate Prisma client: `npx prisma generate`
