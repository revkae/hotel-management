# System Architecture Diagram

## Component View

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT APPLICATIONS                      │
│                    (Postman, Web Browser, etc.)                  │
└────────────────────────────┬────────────────────────────────────┘
                             │ HTTP/REST
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                        API LAYER (REST)                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │   Users      │  │   Hotels     │  │   Reservations       │  │
│  │  Controller  │  │  Controller  │  │   Controller         │  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────────────┘  │
│         │                 │                 │                    │
│         ▼                 ▼                 ▼                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │   Users      │  │   Hotels     │  │   Reservations       │  │
│  │   Service    │  │   Service    │  │    Service           │  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────────────┘  │
└─────────┼──────────────────┼──────────────────┼──────────────────┘
          │                  │                  │
          │                  │                  │ emit events
          │                  │                  ├──────────────┐
          │                  │                  │              │
          ▼                  ▼                  ▼              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      DATA LAYER (Prisma ORM)                     │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                  Prisma Service                          │   │
│  │           (Database Connection & Operations)             │   │
│  └────────────────────────┬─────────────────────────────────┘   │
└───────────────────────────┼─────────────────────────────────────┘
                            │
                            ▼
                  ┌─────────────────┐
                  │  SQLite Database│
                  │   (dev.db)      │
                  └─────────────────┘
                            ▲
                            │ Prisma Schema
                            │
                  ┌─────────┴──────────┐
                  │  Models:           │
                  │  - User            │
                  │  - Hotel           │
                  │  - Reservation     │
                  └────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                   MESSAGING LAYER (RabbitMQ)                     │
│                                                                   │
│              ┌──────────────────────────────┐                    │
│              │   RabbitMQ Message Queue     │                    │
│              │   (reservations_queue)       │                    │
│              └──────────────────────────────┘                    │
│                       ▲              │                           │
│                       │ publish      │ subscribe                │
│                       │              ▼                           │
│              ┌────────┴──────┐  ┌─────────────────┐             │
│              │  Event        │  │  Event          │             │
│              │  Publishers   │  │  Handlers       │             │
│              │               │  │                 │             │
│              │ - created     │  │ @EventPattern   │             │
│              │ - updated     │  │ handlers in     │             │
│              │ - deleted     │  │ controllers     │             │
│              └───────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────┘
```

## Deployment View

```
┌────────────────────────────────────────────────────────────┐
│                    Application Server                      │
│                   (localhost:3000)                         │
│                                                            │
│  ┌──────────────────────────────────────────────────┐    │
│  │          NestJS Application                      │    │
│  │                                                   │    │
│  │  ┌─────────────┐  ┌──────────────┐              │    │
│  │  │   HTTP      │  │ Microservice │              │    │
│  │  │   Server    │  │  (RabbitMQ)  │              │    │
│  │  │             │  │              │              │    │
│  │  │ Port: 3000  │  │ Transport:   │              │    │
│  │  │             │  │   RMQ        │              │    │
│  │  └─────────────┘  └──────────────┘              │    │
│  │                                                   │    │
│  │  ┌─────────────────────────────────────────┐    │    │
│  │  │        Application Modules              │    │    │
│  │  │  - UsersModule                          │    │    │
│  │  │  - HotelsModule                         │    │    │
│  │  │  - ReservationsModule                   │    │    │
│  │  │  - PrismaModule                         │    │    │
│  │  │  - RabbitMQModule                       │    │    │
│  │  └─────────────────────────────────────────┘    │    │
│  └──────────────────────────────────────────────────┘    │
└────────────────────────────────────────────────────────────┘
                            │
                            ▼
        ┌───────────────────────────────────┐
        │     External Dependencies         │
        │                                   │
        │  ┌─────────────────────────────┐ │
        │  │  RabbitMQ Server            │ │
        │  │  localhost:5672             │ │
        │  │  Management: 15672          │ │
        │  └─────────────────────────────┘ │
        │                                   │
        │  ┌─────────────────────────────┐ │
        │  │  SQLite Database            │ │
        │  │  ./dev.db                   │ │
        │  └─────────────────────────────┘ │
        └───────────────────────────────────┘
```

## Data Flow - Reservation Creation Example

```
1. Client sends POST request to /api/reservations
   │
   ▼
2. ReservationsController receives request
   │
   ▼
3. ReservationsService.create() called
   │
   ├─► 4a. PrismaService creates reservation in database
   │        └─► Returns created reservation
   │
   └─► 4b. RabbitMQ Client publishes 'reservation_created' event
            └─► Event placed in reservations_queue
                 │
                 ▼
            5. Event handler receives event
                 │
                 ▼
            6. Console logs event data
```

## Layer Responsibilities

### API Layer (REST Controllers)
**Files**: `*.controller.ts`
- Handle HTTP requests (GET, POST, PATCH, DELETE)
- Validate request data using DTOs
- Return HTTP responses
- Delegate business logic to services

**Endpoints**:
- `/api/users/*` - User management
- `/api/hotels/*` - Hotel management
- `/api/reservations/*` - Reservation management

### Messaging Layer (RabbitMQ)
**Files**: `rabbitmq.module.ts`, event emitters in services
- Asynchronous event-driven communication
- Publish events when reservations are created/updated/deleted
- Subscribe to events for processing
- Decouple components through message queuing

**Events**:
- `reservation_created` - New reservation created
- `reservation_updated` - Reservation modified
- `reservation_deleted` - Reservation removed

### Data Layer (Prisma ORM)
**Files**: `*.service.ts`, `prisma.service.ts`, `schema.prisma`
- Database connection management
- CRUD operations on database entities
- Business logic implementation
- Data validation and relationships

**Models**:
- User (id, name, email, number)
- Hotel (id, hotelName, location)
- Reservation (id, customerName, phone, location, mail, date, userId, hotelId)

## Technology Justification

### Why NestJS?
- Built-in support for microservices
- Modular architecture
- TypeScript support
- Dependency injection
- Easy integration with Prisma and RabbitMQ

### Why Prisma ORM?
- Type-safe database queries
- Auto-generated client
- Database migrations
- Simple schema definition
- Excellent TypeScript support

### Why RabbitMQ?
- Reliable message queuing
- Asynchronous processing
- Event-driven architecture
- Scalable
- Easy integration with NestJS

### Why SQLite?
- Lightweight
- No separate server needed
- Perfect for development
- Easy to share database file
- Simple setup

## Scalability Considerations

The system can be scaled by:
1. **Horizontal Scaling**: Run multiple instances behind a load balancer
2. **Database Migration**: Switch from SQLite to PostgreSQL for production
3. **Message Queue Clustering**: Set up RabbitMQ cluster for high availability
4. **Caching**: Add Redis for frequently accessed data
5. **Microservices**: Split modules into separate microservices
