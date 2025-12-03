import { Module } from '@nestjs/common';
import { ClientsModule, Transport } from '@nestjs/microservices';

@Module({
  imports: [
    ClientsModule.register([
      {
        name: 'RESERVATION_SERVICE',
        transport: Transport.RMQ,
        options: {
          urls: [
            'amqps://yeloctib:VY1wIWh9UlDHcWSsxhirAz_7cSHgGqw-@cow.rmq2.cloudamqp.com/yeloctib',
          ],
          queue: 'reservations_queue',
          queueOptions: {
            durable: false,
          },
        },
      },
    ]),
  ],
  exports: [ClientsModule],
})
export class RabbitmqModule {}
