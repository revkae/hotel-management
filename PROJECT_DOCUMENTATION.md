# Hotel Reservation Management System

## Project Overview
This is a three-layer reservation management system built with NestJS, Prisma ORM, and RabbitMQ for a course assignment.

## Architecture

### 1. API Layer (REST)
REST API endpoints for managing users, hotels, and reservations.

### 2. Messaging Layer (RabbitMQ)
Asynchronous event-driven processing for reservation operations:
- `reservation_created` - Emitted when a new reservation is created
- `reservation_updated` - Emitted when a reservation is updated
- `reservation_deleted` - Emitted when a reservation is deleted

### 3. Data Layer (Prisma ORM)
Persistent data management with SQLite database:
- **User Model**: Stores user information
- **Hotel Model**: Stores hotel information
- **Reservation Model**: Links users to hotels with reservation details

## Technology Stack
- **Framework**: NestJS
- **ORM**: Prisma
- **Message Queue**: RabbitMQ
- **Database**: SQLite
- **Language**: TypeScript

## Prerequisites
- Node.js (v18 or higher)
- RabbitMQ server running on localhost:5672

## Installation

```bash
npm install
```

## Running RabbitMQ

### Using Docker (Recommended)
```bash
docker run -d --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3-management
```

Access RabbitMQ Management UI: http://localhost:15672
- Username: guest
- Password: guest

### Alternative: Local Installation
Download and install RabbitMQ from: https://www.rabbitmq.com/download.html

## Database Setup

The database is already configured with SQLite. To reset or migrate:

```bash
npx prisma db push
npx prisma generate
```

## Running the Application

```bash
# Development mode
npm run start:dev

# Production mode
npm run build
npm run start:prod
```

The application will be available at: http://localhost:3000/api

## API Endpoints

### Users
- `POST /api/users` - Create a new user
- `GET /api/users` - Get all users
- `GET /api/users/:id` - Get user by ID
- `PATCH /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

### Hotels
- `POST /api/hotels` - Create a new hotel
- `GET /api/hotels` - Get all hotels
- `GET /api/hotels/:id` - Get hotel by ID
- `PATCH /api/hotels/:id` - Update hotel
- `DELETE /api/hotels/:id` - Delete hotel

### Reservations
- `POST /api/reservations` - Create a new reservation
- `GET /api/reservations` - Get all reservations
- `GET /api/reservations/:id` - Get reservation by ID
- `PATCH /api/reservations/:id` - Update reservation
- `DELETE /api/reservations/:id` - Delete reservation

## Sample API Calls

### 1. Create a User
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "number": "+1234567890"
  }'
```

### 2. Create a Hotel
```bash
curl -X POST http://localhost:3000/api/hotels \
  -H "Content-Type: application/json" \
  -d '{
    "hotelName": "Grand Plaza Hotel",
    "location": "New York"
  }'
```

### 3. Create a Reservation
```bash
curl -X POST http://localhost:3000/api/reservations \
  -H "Content-Type: application/json" \
  -d '{
    "customerName": "John Doe",
    "phone": "+1234567890",
    "location": "New York",
    "mail": "john@example.com",
    "date": "2025-12-15T14:00:00Z",
    "userId": 1,
    "hotelId": 1
  }'
```

### 4. Get All Reservations
```bash
curl http://localhost:3000/api/reservations
```

## RabbitMQ Event Flow

When a reservation is created, updated, or deleted:

1. **API Request** → REST Controller receives request
2. **Service Layer** → Processes business logic and database operations
3. **Event Emission** → RabbitMQ client emits event to queue
4. **Event Handling** → Event pattern handlers log the events

Example event handling in the console:
```
Reservation created event received: { id: 1, customerName: 'John Doe', ... }
```

## Project Structure

```
src/
├── users/
│   ├── dto/
│   │   ├── create-user.dto.ts
│   │   └── update-user.dto.ts
│   ├── users.controller.ts
│   ├── users.service.ts
│   └── users.module.ts
├── hotels/
│   ├── dto/
│   │   ├── create-hotel.dto.ts
│   │   └── update-hotel.dto.ts
│   ├── hotels.controller.ts
│   ├── hotels.service.ts
│   └── hotels.module.ts
├── reservations/
│   ├── dto/
│   │   ├── create-reservation.dto.ts
│   │   └── update-reservation.dto.ts
│   ├── reservations.controller.ts
│   ├── reservations.service.ts
│   └── reservations.module.ts
├── prisma/
│   ├── prisma.service.ts
│   └── prisma.module.ts
├── rabbitmq/
│   └── rabbitmq.module.ts
├── app.module.ts
└── main.ts
```

## Testing with Postman

Import the following collection structure into Postman:

### Environment Variables
- `baseUrl`: http://localhost:3000/api

### Test Scenario Flow
1. Create a User
2. Create a Hotel
3. Create a Reservation (using IDs from steps 1 and 2)
4. Get All Reservations
5. Update a Reservation
6. Delete a Reservation

Watch the console to see RabbitMQ events being logged.

## Layer Responsibilities

### API Layer (REST)
- **Location**: `*.controller.ts` files
- **Purpose**: Handles HTTP requests and responses
- **Technologies**: NestJS Controllers, DTOs

### Messaging Layer (RabbitMQ)
- **Location**: `rabbitmq.module.ts`, event emitters in services
- **Purpose**: Asynchronous event-driven communication
- **Technologies**: @nestjs/microservices, RabbitMQ

### Data Layer (Prisma ORM)
- **Location**: `*.service.ts` files, `prisma.service.ts`
- **Purpose**: Database operations and business logic
- **Technologies**: Prisma Client, SQLite

## Common Issues

### RabbitMQ Connection Error
If you see connection errors:
1. Ensure RabbitMQ is running on localhost:5672
2. Check if the RabbitMQ service is started
3. Verify firewall settings

### Prisma Client Not Found
```bash
npx prisma generate
```

## For Presentation

### 1-Minute Demo Video Contents
1. Show architectural diagram
2. Start RabbitMQ
3. Start the application
4. Make a POST request to create a reservation
5. Show the RabbitMQ event log in console
6. Show the database entry with GET request

### Presentation Points
- Explain the three-layer architecture
- Show how API layer communicates with Data layer
- Demonstrate RabbitMQ message flow
- Highlight Prisma ORM benefits

## Contributors
- Your Name - [Your Layer Responsibility]

## License
UNLICENSED
