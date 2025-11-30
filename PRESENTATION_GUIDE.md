# Presentation Guide (5 Minutes)

## Before Presentation
- [ ] Ensure RabbitMQ is running (docker or local)
- [ ] Test the application (npm run start:dev)
- [ ] Have Postman collection ready
- [ ] Prepare architectural diagram (ARCHITECTURE.md)
- [ ] Have terminal/console visible for RabbitMQ events

## Presentation Structure (5 minutes)

### Slide 1: Introduction (30 seconds)
**Project**: Hotel Reservation Management System
**Technologies**:
- NestJS (REST API)
- Prisma ORM (Database)
- RabbitMQ (Messaging)
- SQLite (Database)

### Slide 2: Architecture Overview (1 minute)
Show the component diagram from ARCHITECTURE.md

**Three Layers**:
1. **API Layer (REST)** - HTTP endpoints for CRUD operations
2. **Data Layer (Prisma ORM)** - Database management with relations
3. **Messaging Layer (RabbitMQ)** - Event-driven asynchronous processing

**Database Models**:
- User (customers making reservations)
- Hotel (available hotels)
- Reservation (links users to hotels with booking details)

### Slide 3: API Layer Demo (1.5 minutes)
**Live Demo**: Show Postman collection

1. **Show endpoints structure**:
   - Users: /api/users
   - Hotels: /api/hotels
   - Reservations: /api/reservations

2. **Execute requests**:
   - POST /api/users (Create user) → Show response
   - POST /api/hotels (Create hotel) → Show response
   - POST /api/reservations (Create reservation) → Show response

3. **Highlight**:
   - REST principles (GET, POST, PATCH, DELETE)
   - JSON request/response format
   - Status codes (200, 201, etc.)

### Slide 4: Data Layer Demo (1 minute)
**Show Prisma integration**:

1. **Open `reservations.service.ts`** - Show data layer code:
   ```typescript
   this.prisma.reservation.create({
     data: createReservationDto,
     include: {
       user: true,
       hotel: true,
     },
   });
   ```

2. **Execute GET /api/reservations** in Postman:
   - Show how it returns reservation WITH related user and hotel data
   - Explain Prisma's relation handling

3. **Highlight**:
   - Type-safe queries
   - Automatic relations
   - ORM benefits

### Slide 5: Messaging Layer Demo (1 minute)
**Show RabbitMQ integration**:

1. **Point to console/terminal** showing application logs

2. **Create a new reservation** in Postman

3. **Show event in console**:
   ```
   Reservation created event received: { id: 3, customerName: '...', ... }
   ```

4. **Open `reservations.service.ts`** - Show event emission:
   ```typescript
   this.client.emit('reservation_created', reservation);
   ```

5. **Highlight**:
   - Event-driven architecture
   - Asynchronous processing
   - Decoupled components
   - Could trigger emails, notifications, etc.

### Slide 6: Summary (30 seconds)
**What We Built**:
- ✅ REST API with full CRUD operations
- ✅ Database with Prisma ORM and relations
- ✅ RabbitMQ event-driven messaging
- ✅ Scalable, modular architecture

**Key Achievements**:
- Three-layer architecture as required
- All technologies properly integrated
- Working reservation management system
- Demonstrates modern backend development practices

## Q&A Preparation

### Expected Questions & Answers:

**Q: Why did you choose these technologies?**
A: NestJS provides built-in support for microservices and great TypeScript integration. Prisma offers type-safe database queries. RabbitMQ is industry-standard for message queuing. They work seamlessly together.

**Q: How does the messaging layer work?**
A: When a reservation is created/updated/deleted, the service emits an event to RabbitMQ. Event handlers subscribe to these events and process them asynchronously. This decouples components and enables scalability.

**Q: What are the benefits of using Prisma?**
A: Type-safe queries, auto-generated client, easy migrations, excellent relation handling, and great developer experience.

**Q: How would you scale this system?**
A: Horizontal scaling with multiple instances, switch to PostgreSQL, add Redis caching, implement load balancing, and potentially split into separate microservices.

**Q: What about authentication/authorization?**
A: For production, we'd add JWT authentication, role-based access control, and secure the API endpoints. This prototype focuses on the core architecture.

**Q: How do you handle errors?**
A: NestJS provides exception filters. We'd add global error handling, validation pipes, and proper error responses. RabbitMQ ensures message delivery even if services are temporarily down.

**Q: Can you show the database schema?**
A: Show prisma/schema.prisma file with User, Hotel, and Reservation models and their relations.

**Q: What happens if RabbitMQ is down?**
A: The API would still work, but events wouldn't be queued. In production, we'd implement retry logic and dead-letter queues.

## Demo Checklist

### Pre-Demo:
- [ ] RabbitMQ running
- [ ] Application running (npm run start:dev)
- [ ] Postman open with collection loaded
- [ ] Console visible
- [ ] Database has some test data (optional)

### During Demo:
- [ ] Show architecture diagram
- [ ] Execute 3-4 API calls in Postman
- [ ] Highlight console event logs
- [ ] Show code briefly (service.ts files)
- [ ] Explain the flow

### Post-Demo:
- [ ] Answer questions
- [ ] Share code repository
- [ ] Provide documentation

## 1-Minute Video Script

**Scene 1 (10s)**: Show architectural diagram
> "This is a hotel reservation management system with three layers: REST API, Prisma ORM, and RabbitMQ messaging."

**Scene 2 (15s)**: Show Postman
> "The API layer provides REST endpoints. I'll create a reservation by sending a POST request with customer details, user ID, and hotel ID."

**Scene 3 (15s)**: Show Response + Console
> "The data layer uses Prisma to store the reservation with relations. Notice the response includes the full user and hotel data."

**Scene 4 (15s)**: Highlight Console Event
> "The messaging layer publishes events to RabbitMQ. See the 'reservation_created' event logged here. This enables asynchronous processing like sending confirmation emails."

**Scene 5 (5s)**: Summary
> "All three layers working together in a scalable, modern backend architecture."

## Code Snippets to Show (Optional)

### API Layer (Controller):
```typescript
@Post()
create(@Body() createReservationDto: CreateReservationDto) {
  return this.reservationsService.create(createReservationDto);
}
```

### Data Layer (Service):
```typescript
async create(createReservationDto: CreateReservationDto) {
  const reservation = await this.prisma.reservation.create({
    data: createReservationDto,
    include: { user: true, hotel: true },
  });
  // ... messaging code
}
```

### Messaging Layer (RabbitMQ):
```typescript
this.client.emit('reservation_created', reservation);
```

### Event Handler:
```typescript
@EventPattern('reservation_created')
handleReservationCreated(data: any) {
  console.log('Reservation created event received:', data);
}
```

## Files to Share

After presentation, share these files:
- Code repository (GitHub link)
- `PROJECT_DOCUMENTATION.md` - Full documentation
- `ARCHITECTURE.md` - Architectural diagrams
- `Postman_Collection.json` - API testing collection
- `QUICKSTART.md` - Setup instructions

## Tips for Success

1. **Practice the demo** - Run through it 2-3 times
2. **Have backup data** - Pre-create some users/hotels in case of issues
3. **Keep it simple** - Don't overcomplicate explanations
4. **Show confidence** - You built a real, working system!
5. **Time management** - Stick to 5 minutes
6. **Prepare for questions** - Review Q&A section above

## Backup Plan

If live demo fails:
1. Show screenshots of successful API calls
2. Walk through the code instead
3. Explain the architecture conceptually
4. Show the Postman collection structure

Good luck with your presentation!
